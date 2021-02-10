$SystemEnc = Get-CimInstance -Classname Win32_SystemEnclosure
$SN = $SystemEnc.SerialNumber
$NewName = $SN
$RegLoc = 'HKLM:\SOFTWARE\CustomInv'

## Test for Matching name
if(($env:COMPUTERNAME) -notmatch $NewName){
    ## Preserve Old Name
    Write-Output "Adding current computer name to registry location $RegLoc."
    Set-ItemProperty -Path "$RegLoc" -Name "OldName" -Value $env:COMPUTERNAME

    ## Renaming the PC
    Write-Output "Changing computer name to $NewName"
    Rename-Computer -NewName $NewName -Verbose
}