---
title: VPC Cost Investigation - SSM Interface Endpoints
source_type: notes
source_path: raw/notes/2026-06-21-vpc-ssm-endpoint-cost-note.md
ingest_date: 2026-06-21
status: investigated
tags: [aws, vpc, cost, ssm, session-manager, vpc-endpoint, privatelink, powershell]
---

# VPC Cost Investigation - SSM Interface Endpoints

## Summary

Investigation of why the AWS account (766037821705, Seoul / ap-northeast-2)
appeared to be "leaking money" under VPC. A VPC itself is free; cost always comes
from attached billable resources. The only ongoing billable resource found was
**three Interface VPC Endpoints** (`ssm`, `ssmmessages`, `ec2messages`) created
2026-05-30 in VPC `vpc-0553be49707dd7a26`, subnet `subnet-0d99ae355cf0dd527`,
security group `sg-0a6a6a34e72e31f33`, private DNS enabled. Estimated
~$28/month + data processing. NAT Gateway, Elastic IP, VPN, and Transit Gateway
were 0 across all regions checked.

These endpoints exist to allow SSM Session Manager access to a DB server placed
in a private subnet (no public IP, no NAT). Confirmed they are actually used, not
zombie resources. Two PowerShell helper scripts (`scripts/ssm-on.ps1`,
`scripts/ssm-off.ps1`) were created and verified to toggle the endpoints on/off
so cost drops to near zero when access is infrequent.

## Key Claims

- A VPC is free; recurring "VPC" cost comes from NAT Gateway, Elastic IP,
  Interface VPC Endpoints, VPN, or Transit Gateway.
- The three SSM endpoints are the only ongoing billable VPC resource in the
  account, costing ~$0.013/hr per endpoint per AZ (~$28/month total).
- Gateway endpoints (e.g. S3, `vpce-01629baf9f4c08c48`) are free; only Interface
  endpoints (PrivateLink) bill hourly.
- Session Manager requires all three channels: `ssm` (core API), `ssmmessages`
  (live session terminal I/O), `ec2messages` (EC2 command transport). Missing one
  breaks access.
- SSM works on a private no-public-IP server because the SSM Agent makes an
  outbound connection to AWS; the endpoints provide that path without NAT.
- NAT Gateway and VPC Endpoint are different: NAT routes to the whole internet
  (~$32/mo + data), an Interface endpoint links to one AWS service only. Swapping
  endpoints for NAT would be more expensive and less secure.
- Deleting and recreating the endpoints has no practical side effect: the
  endpoint ID and ENI private IP change, but private DNS abstracts them, so
  `aws ssm start-session --target <id>` is unchanged.
- Endpoint policies were verified as default full-access
  (`Action:*, Resource:*, Principal:*`), so recreate reproduces them exactly.
- Helper scripts find endpoints by service name (no hardcoded IDs) and are
  idempotent; `ssm-on.ps1` waits until all reach `available`.
- The CLI session uses the AWS account root identity
  (`arn:aws:iam::766037821705:root`) and requires `aws login` re-auth when the
  session expires.

## Caveats

- Cost Explorer had not yet surfaced the charges at investigation time (billing
  data lag plus endpoints only created 2026-05-30), but the resources are real
  and accruing.
- After turning endpoints on, they take 2-5 minutes to reach `available` before
  `start-session` works; deleting during an active session drops that session.
- Only real breakage risk on recreate: an IAM or S3 bucket policy pinning the
  endpoint IDs via an `aws:SourceVpce` condition (unlikely for SSM, none known).
- A full live off->on cycle was not run during verification (would briefly
  interrupt SSM access); scripts were validated via PowerShell parse check, AWS
  `--dry-run`, and read-only lookups, leaving live endpoints untouched.
- Cost figures are list-price estimates, not pulled from a settled bill.
- Using the AWS root identity for daily CLI work conflicts with the account
  hardening guidance in the related AWS answer pages.

## Related Pages

- [[aws-root-user-vs-iam-user]]
- [[aws-organizations-identity-center-account-model]]
- [[laimory]]
