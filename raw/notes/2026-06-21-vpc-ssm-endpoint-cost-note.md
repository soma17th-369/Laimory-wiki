---
source_type: notes
title: VPC cost investigation - SSM interface endpoints
captured_at: 2026-06-21
status: raw-decision-note
---

# VPC Cost Investigation - SSM Interface Endpoints

## Context

Suspected that the AWS account (766037821705, Seoul / ap-northeast-2) was
leaking money under "VPC". A VPC itself is free, so the cost always comes from
attached billable resources. Investigated with AWS CLI.

## What Was Found

The only ongoing billable resource is **3 Interface VPC Endpoints** created on
2026-05-30, all in the same VPC `vpc-0553be49707dd7a26`, same subnet
`subnet-0d99ae355cf0dd527`, same security group `sg-0a6a6a34e72e31f33`, with
private DNS enabled.

| Endpoint ID | Service | Type | Billing |
|---|---|---|---|
| vpce-03c736febe96297c5 | ssm | Interface | hourly |
| vpce-0942aebf4187c0e28 | ssmmessages | Interface | hourly |
| vpce-036efe48d6d5245a3 | ec2messages | Interface | hourly |
| vpce-01629baf9f4c08c48 | s3 | Gateway | free |

Estimated cost: ~$0.013/hr per endpoint per AZ x 3 endpoints x ~720 hr
≈ **~$28/month** + data processing.

Clean elsewhere: NAT Gateway, Elastic IP, VPN, Transit Gateway are all **0**
across every region checked (us-east-1, us-west-2, ap-northeast-1,
ap-southeast-1, eu-west-1, ap-northeast-2). Cost Explorer had not yet surfaced
the charges (billing data lag + endpoints only created 5/30), but the resources
are real and accruing.

## Why These Endpoints Exist

They were created when the DB server was placed in a **private subnet**.

- SSM = AWS Systems Manager. Its Session Manager feature lets you open a
  terminal into a server **without a public IP, without opening SSH port 22,
  and without a bastion host**.
- A private server has no public IP, so inbound SSH is impossible (this is
  intentional and good for security). But you still need *some* way in for
  administration.
- SSM works because the direction is reversed: the SSM Agent on the server makes
  an **outbound** connection to AWS, so no public IP is needed.

```
SSH (inbound):    internet --in--> server    blocked without public IP
SSM (outbound):   server --out--> AWS         works, no public IP needed
```

- But a private subnet with no NAT has no internet path at all, so the Agent
  cannot even reach AWS. The 3 interface endpoints carve a **direct private path
  inside the VPC to the SSM service**, so no NAT / no public IP is required.

Why 3 endpoints: Session Manager needs all three channels.

| Endpoint | Role |
|---|---|
| ssm | core SSM API (register commands, status) |
| ssmmessages | Session Manager live session channel (terminal I/O) |
| ec2messages | EC2 <-> SSM command transport |

Missing any one breaks Session Manager. This "SSM trio" is a normal, correct setup.

## NAT Gateway vs VPC Endpoint (clarification)

These are NOT the same thing.

| | NAT Gateway | VPC Endpoint (current) |
|---|---|---|
| Purpose | sends private server to the **whole internet** | direct link to a **specific AWS service** only |
| Path | server -> NAT -> internet -> anywhere | server -> endpoint -> SSM (no internet) |
| Cost | ~$32/mo + data | ~$9.4/mo each (3 ≈ $28) |

The DB does not need the internet, so NAT was correctly never created. The cost
comes purely from the management-access path (SSM endpoints). Replacing them with
a NAT Gateway would be **more** expensive and less secure, so that is not a fix.

## Cost-Saving Option: Turn Endpoints On/Off On Demand

All 3 endpoints share the same subnet + security group + private DNS, and the
security group and subnet are **not deleted** when the endpoints are removed.
So they can be deleted when not connecting and recreated when needed.
If the DB is only accessed a few days a month: **~$28 -> under ~$1**.

### Off (stop billing)

```powershell
aws ec2 delete-vpc-endpoints --region ap-northeast-2 `
  --vpc-endpoint-ids vpce-03c736febe96297c5 vpce-0942aebf4187c0e28 vpce-036efe48d6d5245a3
```

### On (when access is needed)

```powershell
foreach ($svc in "ssm","ssmmessages","ec2messages") {
  aws ec2 create-vpc-endpoint --region ap-northeast-2 `
    --vpc-endpoint-type Interface `
    --vpc-id vpc-0553be49707dd7a26 `
    --service-name "com.amazonaws.ap-northeast-2.$svc" `
    --subnet-ids subnet-0d99ae355cf0dd527 `
    --security-group-ids sg-0a6a6a34e72e31f33 `
    --private-dns-enabled
}
```

## Side Effects of Delete/Recreate

Unlike an EC2 instance (whose public IP changes on stop/start and can break
hardcoded references), recreating these endpoints has **no practical side
effect**, because every identifier that changes is hidden behind the service
DNS name.

| Changes on recreate | EC2 equivalent | Impact |
|---|---|---|
| Endpoint ID (vpce-xxx) | instance ID | none - never referenced when using SSM |
| ENI private IP | public IP change | none - private DNS auto-remaps it |

With `PrivateDnsEnabled = true`, `ssm.ap-northeast-2.amazonaws.com` always
resolves to the endpoint's current private IP automatically. So even if the
internal IP changes, the connect command stays identical:
`aws ssm start-session --target i-xxxx`.

Endpoint policies were verified to be **default full-access**
(`Action:*, Resource:*, Principal:*`) on all three — nothing custom to preserve;
recreate reproduces them exactly. Security group, subnet, and the DB server are
untouched.

### Practical cautions (operational, not data-loss)

1. After turning on, the endpoints take **2-5 min** to reach `available` before
   `start-session` works.
2. Deleting while a session is active drops that session — turn off only after
   finishing work.
3. Only real breakage risk: if any IAM or S3 bucket policy pins these endpoint
   IDs via an `aws:SourceVpce` condition, recreate (new IDs) would break it.
   Unlikely for SSM endpoints and none known here.

## Decision / Status

- Confirmed all 3 endpoints are actually used (legitimate SSM access to the
  private DB server), not zombie resources.
- The ~$28/month is a reasonable cost for keeping the DB fully private if
  accessed frequently.
- If access is infrequent, the on/off scripts above reduce it to near zero with
  no meaningful side effects.
- Helper scripts created and verified: `scripts/ssm-on.ps1` (create + wait until
  `available`) and `scripts/ssm-off.ps1` (delete to stop billing). Both are
  idempotent and find endpoints by service name (no hardcoded IDs). Verified via
  PowerShell parse check + AWS `--dry-run` (permissions/params OK) + read-only
  lookups; live endpoints were left untouched (still `available`).

## Prerequisite: AWS Login

The AWS CLI session expires and must be re-authenticated before any of these
commands or scripts will work. If you see
`Your session has expired. Please reauthenticate using 'aws login'`, run:

```powershell
aws login          # opens browser; account 766037821705, region ap-northeast-2
```

`aws sso login` is the equivalent if an SSO profile is configured. Confirm you
are authenticated with:

```powershell
aws sts get-caller-identity
```

## Script Usage

Location: `C:\suhyun444\dev\Laimory-wiki\scripts\`

```powershell
# 0. make sure you are logged in (see Prerequisite above)
aws sts get-caller-identity

cd C:\suhyun444\dev\Laimory-wiki\scripts

# 1. before connecting: create endpoints and wait until ready (2-5 min)
.\ssm-on.ps1

# 2. connect to the private DB server (no public IP / SSH needed)
aws ssm start-session --region ap-northeast-2 --target <instance-id>

# 3. when finished: delete endpoints to stop hourly billing (~$28/mo while off)
.\ssm-off.ps1
```

Options:

- `.\ssm-on.ps1 -DryRun` / `.\ssm-off.ps1 -DryRun` - validate permissions and
  parameters without making any changes (used for verification).
- `.\ssm-on.ps1 -TimeoutSec 900` - raise the max wait time for endpoints to
  reach `available` (default 600 s).

Notes:

- Both scripts are safe to re-run: `ssm-on` skips services that already exist,
  `ssm-off` reports "already off" if nothing is found.
- If PowerShell blocks script execution, allow the current session with:
  `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
