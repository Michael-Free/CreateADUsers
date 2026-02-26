<#
.SYNOPSIS
A PowerShell module for generating and deploying test user data in Active Directory environments.

.DESCRIPTION
CreateADUsers is a PowerShell-native framework that automates the creation of realistic test users in Active Directory. The module generates comprehensive user accounts with names, departments, job titles, compliant passwords, and all necessary AD attributes. Each account creation is logged with username and password details for immediate testing. The module handles duplicate account names by auto-incrementing, ensures unique user generation, and provides detailed error handling and logging.

.INPUTS
None. This module does not accept pipeline input at the module level.

.OUTPUTS
None. This module does not output objects at the module level..

.EXAMPLE
Import-Module -Name CreateADUsers
New-TestADUser -Amount 10

Imports the module and creates 10 test users in Active Directory with a log file containing their credentials.

.NOTES
Author: Michael Free
Date Created: February 23, 2024
Module Name: CreateADUsers
#>
try {
  Import-Module FreeLog -ErrorAction Stop
}
catch {
  throw 'FreeLog module is required. Install it with: Install-Module -Name FreeLog'
}
try {
  Import-Module ActiveDirectory -ErrorAction Stop
}
catch {
  throw 'ActiveDirectory module not found. This must run on a Domain Controller'
}
foreach ($folder in @('Private', 'Public')) {
  $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
  if (Test-Path -Path $root) {
    Write-Verbose "processing folder $root"
    $files = Get-ChildItem -Path $root -Filter '*.ps1'
    $files | Where-Object { $_.Name -notlike '*.Tests.ps1' } |
      ForEach-Object {
        Write-Verbose "Dot-sourcing $($_.Name)"
        . $_.FullName
      }
  }
}
$exportedFunctions = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter '*.ps1').BaseName
Export-ModuleMember -Function $exportedFunctions

