<#
.SYNOPSIS
  Recreates the SSM interface VPC endpoints and waits until they are usable.
.DESCRIPTION
  Creates the ssm / ssmmessages / ec2messages interface endpoints in the target
  VPC (same subnet, security group, and private DNS as the original setup), then
  polls until all three reach the "available" state so that
  `aws ssm start-session` will work immediately afterward.

  Idempotent: if an endpoint for a service already exists (not deleting/deleted),
  it is skipped instead of creating a duplicate.
.PARAMETER DryRun
  Validates permissions/parameters via the AWS DryRun flag without creating.
.PARAMETER TimeoutSec
  Max seconds to wait for all endpoints to become available (default 600).
.EXAMPLE
  .\ssm-on.ps1             # create + wait until ready
  .\ssm-on.ps1 -DryRun     # validate only, no changes
#>
[CmdletBinding()]
param(
    [switch]$DryRun,
    [int]$TimeoutSec = 600
)

$ErrorActionPreference = "Stop"

# ---- config (Seoul / Laimory DB private VPC) ----
$Region   = "ap-northeast-2"
$VpcId    = "vpc-0553be49707dd7a26"
$SubnetId = "subnet-0d99ae355cf0dd527"
$SgId     = "sg-0a6a6a34e72e31f33"
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

function Get-EndpointState {
    param([string]$ServiceName)
    $s = Invoke-Aws @(
        "ec2", "describe-vpc-endpoints", "--region", $Region,
        "--filters", "Name=vpc-id,Values=$VpcId", "Name=service-name,Values=$ServiceName",
        "--query", "VpcEndpoints[?State!='deleting' && State!='deleted'].State | [0]",
        "--output", "text"
    )
    return ($s | Out-String).Trim()
}

Write-Host "Ensuring SSM endpoints exist in $VpcId ($Region)..." -ForegroundColor Cyan

foreach ($svc in $Services) {
    $svcName = "com.amazonaws.$Region.$svc"
    $state = Get-EndpointState -ServiceName $svcName
    if ($state -and $state -ne "None" -and $state -ne "") {
        Write-Host "  $svc already present (state: $state) - skip" -ForegroundColor DarkGray
        continue
    }
    Write-Host "  creating $svc ..." -ForegroundColor Cyan
    $create = @(
        "ec2", "create-vpc-endpoint", "--region", $Region,
        "--vpc-endpoint-type", "Interface",
        "--vpc-id", $VpcId,
        "--service-name", $svcName,
        "--subnet-ids", $SubnetId,
        "--security-group-ids", $SgId,
        "--private-dns-enabled"
    )
    if ($DryRun) { $create += "--dry-run" }
    Invoke-Aws -CliArgs $create -AllowDryRun:$DryRun | Out-Null
}

if ($DryRun) {
    Write-Host "Dry run complete. No changes made." -ForegroundColor Green
    exit 0
}

Write-Host "Waiting for endpoints to become available (up to $TimeoutSec s)..." -ForegroundColor Cyan
$deadline = (Get-Date).AddSeconds($TimeoutSec)
while ($true) {
    $states = @()
    foreach ($svc in $Services) {
        $states += Get-EndpointState -ServiceName "com.amazonaws.$Region.$svc"
    }
    $notReady = $states | Where-Object { $_ -ne "available" }
    if (-not $notReady) {
        Write-Host "All endpoints available. SSM ready." -ForegroundColor Green
        Write-Host "Connect with: aws ssm start-session --region $Region --target <instance-id>"
        exit 0
    }
    if ((Get-Date) -gt $deadline) {
        Write-Host "Timeout. Current states: $($states -join ', ')" -ForegroundColor Red
        throw "Endpoints did not all become available within $TimeoutSec s."
    }
    Write-Host "  states: $($states -join ', ') - waiting 15s..." -ForegroundColor DarkGray
    Start-Sleep -Seconds 15
}
