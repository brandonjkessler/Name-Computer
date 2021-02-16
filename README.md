# Set-ComputerName

## Prerequisites
* Requires Elevated Privileges to run.
* Requires PowerShell 5.1 on Windows.

## Overview
Sets the computer name to the serial number with a prefix, suffix, or both.

## Description
Sets the computer name to the serial number with a prefix, suffix, or both.  
Trims the name down to 15 characters to comply with Windows requirements.  
Will preserve the old name to a registry location if using parameters.  
To use you must first import the module or copy to the module directory.  

## Parameters
* Prefix
  * Adds the string specified to the front of the name.
* Suffix
  * Adds the string specified to the end of the name.
* Registry
  * Location in registry to write the old name information.
* KeepOldName
  * Switch that preserves the old name if set.

## Examples

    Set-ComputerName -Prefix 'ORG'

    Set-ComputerName -Prefix 'ORG-' -Registry 'HKLM:\SOFTWARE\ORG\Inventory' -KeepOldName

    Set-ComputerName -Suffix '-ORG'

