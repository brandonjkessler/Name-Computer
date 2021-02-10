#Requires -RunAsAdministrator

[CmdletBinding()]
param (
    [Parameter(ValueFromPipelineByPropertyName,
    HelpMessage='Adds a set of characters before the Serial Number.')]
    [String]
    $Prefix,
    [Parameter(ValueFromPipelineByPropertyName,
    HelpMessage='Adds a set of characters after the Serial Number.')]
    [String]
    $Suffix,
    [Parameter(HelpMessage='Sets a location in registry.')]
    [string]
    $Registry = 'HKLM:\SOFTWARE\CustomInv',
    [Parameter(HelpMessage='Write old name to a registry file.')]
    [switch]
    $KeepOldName

)

$SystemEnc = Get-CimInstance -Classname Win32_SystemEnclosure
$SN = $SystemEnc.SerialNumber

$NewName = "$SN"

## Test for Prefix and Suffix
if($null -ne $Prefix){
    $NewName = "$Prefix" + "$NewName"
}
if($null -ne $Suffix){
    $NewName = "$NewName" + "$Suffix"
}

## Test for Matching name
if(($env:COMPUTERNAME) -notmatch $NewName){
    ## test for Reg path and create it if needed
    if(!(Test-Path -Path $Registry)){
        New-Item -Path $Registry
    }

    if($KeepOldName -eq $true){
        ## Preserve Old Name
        Write-Output "Adding current computer name to registry location $Registry."
        Set-ItemProperty -Path "$Registry" -Name "OldName" -Value $env:COMPUTERNAME
    }
    
    ## Testing $NewName Length
    if($NewName.length() -gt 15){
        $NewName = $NewName.Substring(0,15)
    }
    ## Renaming the PC
    Write-Output "Changing computer name to $NewName"
    Rename-Computer -NewName $NewName -Verbose
}