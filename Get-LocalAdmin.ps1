<#
.Synopsis
   Anzeigen der Lokalen Administratoren
.DESCRIPTION
   Skript zum auslesen der User auf einem oder mehreren Remote Computern welche zu den lokalen Administratoren gehören
.Notes
    Version: 1.0
    Author:  Stefan Ober
    E-Mail:  StefanO (at) ppedv.de
.EXAMPLE
   .\Get-LocalAdmin.ps1 -ComputerName localhost
#>
[cmdletBinding()]
[OutputType([string[]])]
Param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({Write-Host "Prüfen der Verbindung" -ForeGroundColor Yellow;
                     if(Test-Connection -Quiet -ComputerName $PSItem )
                     {
                        Write-Host "Prüfung erfolgreich, $PSitem erreichbar über ICMP" -ForegroundColor Green
                        $true
                     }else
                     {
                        throw "Gerät nicht erreichbar"
                     }})]
    [string[]]$ComputerName
)
    $Ergebnisse = New-Object System.Collections.Generic.List[object]
    foreach($Computer in $ComputerName)
    {
    
        if($UserNames -ne $null)
        {
            Clear-Variable UserNames
        }
        $group = Get-WmiObject win32_group -Filter "LocalAccount=True AND SID='S-1-5-32-544'" -Computer $Computer
        $query = "GroupComponent = `"Win32_Group.Domain='$($group.domain)'`,Name='$($group.name)'`""
        $list = Get-WmiObject -Query "Select * FROM Win32_GroupUser WHERE $Query" -Computer "$Computer"

        Write-Verbose ($list.PartComponent).ToString()
    
            foreach($Name in $list)
            {        
                $Ergebniss = New-Object Psobject -Property @{
                                                            Computer= $Name.PSComputerName
                                                            UserName = $($($(($Name).PartComponent.split(','))[1]).TrimStart('Name="')).TrimEnd('"')
                                                        }
                $Ergebnisse.Add($Ergebniss)
            }
    }
    return $Ergebnisse
   

    