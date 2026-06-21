<#
.SYNOPSIS
  Deletes the SSM interface VPC endpoints to stop hourly billing.
.DESCRIPTION
  Finds the ssm / ssmmessages / ec2messages interface endpoints in the target
  VPC by service name (so it does not depend on hardcoded endpoint IDs, which
  change on every recreate) and deletes them. Safe to run repeatedly; if none
  exist it reports "already off".

  The security group and subnet are NOT deleted, so ssm-on.ps1 can recreate the
  endpoints later with the same configuration.
.PARAMETER DryRun
  Validates permissions/parameters via the AWS DryRun flag without deleting.
.EXAMPLE
  .\ssm-off.ps1            # delete (stop billing)
  .\ssm-off.ps1 -DryRun    # validate only, no changes
#>
[CmdletBinding()]
param([switch]$DryRun)

$ErrorActionPreference = "Stop"

# ---- config (Seoul / Laimory DB private VPC) ----
$Region   = "ap-northeast-2"
$VpcId    = "vpc-0553be49707dd7a26"
$Services = @("ssm", "ssmmessages", "ec2messages")
# -------------------------------------------------

function Invoke-Aws {
    param([string[]]$CliArgs, [switch]$AllowDryRun)
    # PS 5.1: capturing native stderr via 2>&1 turns each line into a
    # NativeCommandError ErrorRecord; under -ErrorActionPreference Stop that
    # throws before we can read the exit code. Isolate this call to Continue.
    $prev = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $out  = & aws @CliArgs 2>&1
    $code = $LASTEXITCODE
    $ErrorActionPreference = $prev
    if ($code -ne 0) {
        $text = ($out | Out-String)
        if ($AllowDryRun -and $text -match "DryRun") {
            Write-Host "  [dry-run OK] request would have succeeded" -ForegroundColor DarkGray
            return $null
        }
        Write-Host $text -ForegroundColor Red
        throw "aws failed (exit $code): aws $($CliArgs -join ' ')"
    }
    return $out
}

Write-Host "Looking up SSM endpoints in $VpcId ($Region)..." -ForegroundColor Cyan

$ids = @()
foreach ($svc in $Services) {
    $svcName = "com.amazonaws.$Region.$svc"
    $found = Invoke-Aws @(
        "ec2", "describe-vpc-endpoints", "--region", $Region,
        "--filters", "Name=vpc-id,Values=$VpcId", "Name=service-name,Values=$svcName",
        "--query", "VpcEndpoints[?State!='deleting' && State!='deleted'].VpcEndpointId",
        "--output", "text"
    )
    if ($found) {
        foreach ($id in ($found -split '\s+')) {
            if ($id -and $id -ne "None") { $ids += $id }
        }
    }
}

if ($ids.Count -eq 0) {
    Write-Host "SSM endpoints already off (none found). Nothing to delete." -ForegroundColor Yellow
    exit 0
}

Write-Host "Deleting: $($ids -join ', ')" -ForegroundColor Cyan
$del = @("ec2", "delete-vpc-endpoints", "--region", $Region, "--vpc-endpoint-ids") + $ids
if ($DryRun) { $del += "--dry-run" }
Invoke-Aws -CliArgs $del -AllowDryRun:$DryRun | Out-Null

if ($DryRun) {
    Write-Host "Dry run complete. No changes made." -ForegroundColor Green
} else {
    Write-Host "Done. Hourly billing stopped (~`$28/mo saved while off)." -ForegroundColor Green
}
