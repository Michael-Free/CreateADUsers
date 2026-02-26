<#
.SYNOPSIS
Validates that the script is running on an appropriate Windows Server operating system, preferably a domain controller.

.DESCRIPTION
The Get-OperatingSystemType function checks the current operating system environment to ensure compatibility with Active Directory operations. It verifies that the script is running on Windows (not Linux or macOS), confirms it's running on Windows Server (not client OS), and validates that it's executing on a domain controller. The function throws descriptive errors if any of these conditions are not met.

.PARAMETER None
This function does not accept any parameters.

.INPUTS
None. This function does not accept pipeline input.

.OUTPUTS
System.Boolean
Returns $true if all operating system requirements are met for running Active Directory operations.

.EXAMPLE
Get-OperatingSystemType

Checks the current operating system and returns $true if running on a Windows Server domain controller, otherwise throws an error.

.NOTES
Author: Michael Free
Date Created: February 23, 2024
Module Name: CreateADUsers

Error messages are thrown for:
- Non-Windows operating systems
- Windows client operating systems
- Windows Server that is not a domain controller
#>
function Get-OperatingSystemType {
  switch ($true) {
    $IsWindows { $runningWindows = $true }
    $IsLinux { throw 'Running on Linux. Needs to be Windows Server.' }
    $IsMacOS { throw 'Running on macOS. Needs to be Windows Server.' }
    default { throw 'Unknown Operating System. Needs to be Windows Server.' }
  }
  if ($runningWindows) {
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    if (-not ($osInfo.ProductType -eq 2 -or $osInfo.ProductType -eq 3)) {
      throw 'CreateADUsers must be ran on Windows Server.'
    }
    if (-not ($osInfo.ProductType -eq 2)) {
      throw 'CreateADUsers must be ran on a domain controller.'
    }
  }
  return $true
}

