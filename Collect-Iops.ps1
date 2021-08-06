<#
.SYNOPSIS
    Get Read/Write IOPS for VM

.NOTES
    Author: Krzysztof Zaleski (krzysztof_zaleski@sevenet.pl)
    Date: 2021.08.05
    Version: 1.0
    Disclaimer: This script is provided as-is without any support or responsibility.
                You may copy and modify this script freely as long as you keep
                the reference to the original author.
#>

param
(
    [Parameter(Mandatory=$true)][System.String]$vmName = ""
)

$vcenterIp = "10.0.0.101"
$userName = 'administrator@vsphere.local'
$consoleOut = $false

if ([string]::IsNullOrEmpty($vmName))
{
    Write-Host "VM name missing"
    Write-Host "Usage: Collect-Iops.ps1 -vmName <vmaname>"
    exit(1)
}

# VMware collects samples every 20 sec
$samples = 30
# 1 Minute = 3
# 1 Hour = 180
# 1 Day = 4320

$csvFile = "Collected-IOPS-$($vmName)-$(Get-Date -format yyyyMMdd).csv"

New-Item $csvFile -Type file -force | Out-Null
Add-Content $csvFile "TimeStamp,VM,ReadIOPS,WriteIOPS"

Write-Host "$(Get-Date -Format G): Connecting to vCenter: ${vcenterIp}"
$userCred = Get-Credential -UserName $userName -Message "vCenter administrator's credentials:"
$vcConnect = Connect-Viserver $vcenterIp -Credential $userCred -ErrorAction SilentlyContinue

if (-not $vcConnect)
{
    $vcError = $Error[0].Exception.Message -Split "\t"
    Write-Host "$(Get-Date -Format G): " -NoNewline
    Write-Host -ForegroundColor red "Error: $($vcError[3])"
    exit(3)
}

Write-Verbose "$(Get-Date -Format G): Getting VM stats for VM: $($vmName)... ($samples samples)"

$vmObj = Get-VM -Name $vmName -ErrorAction SilentlyContinue

if (-not $vmObj)
{
    Write-Host "VM: $($VmName) does not exist"
    exit(2)
}

if ($vmObj.PowerState -eq "PoweredOff")
{
    Write-Host "VM: $($VmName) is not powered on"
    exit(3)
}

For ($i = 1; $i -le $samples; $i += 1)
{
    $metrics = "virtualdisk.numberreadaveraged.average", "virtualdisk.numberwriteaveraged.average"
    $stats = Get-Stat -Realtime -Stat $metrics -Entity $vmObj -MaxSamples 1
    $interval = $stats[0].IntervalSecs

    Write-Host "$(Get-Date -Format G): ... collecting sample: $i"

    $collected = $stats | Group-Object -Property MetricId

    $readiops = ($collected.Group | Where-Object {$_.MetricId -eq "virtualdisk.numberreadaveraged.average"} | Measure-Object Value -Sum).Sum
    $writeiops = ($collected.Group | Where-Object {$_.MetricId -eq "virtualdisk.numberwriteaveraged.average"} | Measure-Object Value -Sum).Sum

    if ($consoleOut)
    {
        Write-Host "IOPS read: $($readiops), write: $($writeiops)"
    }

    $timestamp = $collected.Group | Group-Object -Property Timestamp
    $ts = $timestamp.Name
    $line = "$ts,$vmName,$readiops,$writeiops"
    Add-Content $csvFile "$line"

    if ($i -ne $samples)
    {
        Start-Sleep -s $interval
    }
}

Disconnect-Viserver $vcenterIp -Confirm:$false -WarningAction SilentlyContinue
