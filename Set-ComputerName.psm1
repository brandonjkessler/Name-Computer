#Requires -RunAsAdministrator
<#
    .SYNOPSIS
    Sets the computer name to the serial number with a prefix, suffix, or both.

    .DESCRIPTION
    Sets the computer name to the serial number with a prefix, suffix, or both.
    Trims the name down to 15 characters to comply with Windows requirements.
    Will preserve the old name to a registry location if using parameters.

    .PARAMETER Prefix
    Adds the string specified to the front of the name.

    .PARAMETER Suffix
    Adds the string specified to the end of the name.

    .PARAMETER RegistryPath
    Location in registry to write the old name information.
    
    .PARAMETER RegistryKey
    Key in registry to write the old name information.

    .PARAMETER KeepOldName
    Switch that preserves the old name if set.

    .INPUTS
    Accepts inputs from pipeline that are Prefix or Suffix.

    .OUTPUTS
    None.

    .EXAMPLE
    Set-ComputerName -Prefix 'ORG'

    .EXAMPLE
    Set-ComputerName -Prefix 'ORG-' -RegistryPath 'HKLM:\SOFTWARE\ORG' -RegistryKey 'Inventory' -KeepOldName

    .EXAMPLE
    Set-ComputerName -Suffix '-ORG'

    .LINK
    Rename-Computer
#>


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
    [Parameter(ValueFromPipelineByPropertyName,
    HelpMessage='Sets a location in registry.')]
    [string]
    $RegistryPath = 'HKLM:\SOFTWARE',
    [Parameter(ValueFromPipelineByPropertyName,
    HelpMessage='Sets a location in registry.')]
    [string]
    $RegistryKey = 'CustomInv',
    [Parameter(HelpMessage='Write old name to a registry file.')]
    [switch]
    $KeepOldName

)

$SystemEnc = Get-CimInstance -Classname Win32_SystemEnclosure
$SN = $SystemEnc.SerialNumber
$Registry = "$RegistryPath\$RegistryKey"

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
    if((Test-Path -Path $Registry) -ne $true){
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