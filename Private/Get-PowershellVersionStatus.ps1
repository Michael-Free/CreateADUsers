<#
.SYNOPSIS
Validates that the current PowerShell version is 7.0 or higher.

.DESCRIPTION
The Get-PowershellVersionStatus function checks the major version of PowerShell currently running. It returns $true if the version is 7.0 or greater, and throws a descriptive error if an older version (Windows PowerShell 5.1 or earlier) is detected. This validation ensures compatibility with features and syntax used in the CreateADUsers module that require PowerShell 7+.

.PARAMETER None
This function does not accept any parameters.

.INPUTS
None. This function does not accept pipeline input.

.OUTPUTS
System.Boolean
Returns $true if PowerShell 7 or higher is detected. If an older version is detected, an error is thrown instead of returning a value.

.EXAMPLE
Get-PowershellVersionStatus

Checks the current PowerShell version. Returns $true if version 7.0 or higher is running, otherwise throws an error with the current version number.

.NOTES
Author: Michael Free
Date Created: February 23, 2024
Module Name: CreateADUsers

This function is essential for ensuring compatibility with:
- Advanced PowerShell 7+ features used in the module
- Cross-platform compatibility requirements
- Modern Active Directory module cmdlets that may require newer PowerShell versions

The function reads from the automatic $PSVersionTable variable which contains the current PowerShell version information.
#>
function Get-PowershellVersionStatus {
  if ($PSVersionTable.PSVersion.Major -ge 7) {
    return $true
  }
  else {
    $currentVersion = $PSVersionTable.PSVersion.ToString()
    $errorMessage = "Current Powershell Version: $currentVersion. Please install Powershell 7 or higher."
    throw $errorMessage
  }
}
