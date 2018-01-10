<#
.Synopsis
   Anzeigen der Lokalen Administratoren
.DESCRIPTION
   cmdLet zum auslesen der lokalen User auf lokalem oder Remote Computer welche zu den lokalen Administratoren gehören
.EXAMPLE
   .\Get-LocalAdmin.ps1 -ComputerName localhost
#>
[cmdletBinding()]
[OutputType([string[]])]
Param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Connection -Quiet -ComputerName $PSItem})]
    [string]$ComputerName
)
    Clear-Variable UserNames

    $group = Get-WmiObject win32_group -Filter "LocalAccount=True AND SID='S-1-5-32-544'"
    $query = "GroupComponent = `"Win32_Group.Domain='$($group.domain)'`,Name='$($group.name)'`""
    $list = Get-WmiObject -Query "Select * FROm Win32_GroupUser WHERE $Query" -ComputerName "$Computername"

    Write-Verbose ($list.PartComponent).ToString()

    foreach($Name in $list)
    {
        $UserNames = $UserNames,$(($Name).PartComponent.split(','))[1]
    }

    return $UserNames
    

