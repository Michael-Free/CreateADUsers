<#
.SYNOPSIS
Creates Active Directory user accounts from a CSV file.

.DESCRIPTION
This script imports a list of user account details from a CSV file and creates corresponding Active Directory user accounts. 
It validates prerequisites, including administrative privileges, operating system type, and input data formats, before attempting 
to create accounts. Accounts are created with attributes such as display name, email address, department, and more.

.PARAMETER CsvPath
The path to the CSV file containing the user data. Each row in the file represents a user and must contain the required fields.

.PARAMETER Domain
The fully qualified domain name (FQDN) of the target Active Directory domain where the accounts will be created.

.EXAMPLE
.\Create-ADUsers.ps1 -CsvPath "C:\Users.csv" -Domain "example.com"
This example creates user accounts in the "example.com" domain using the user data from "C:\Users.csv".

.INPUTS
[string]$CsvPath
[string]$Domain

.OUTPUTS
None. This script performs operations but does not return output.

.NOTES
- Ensure the script is run with administrative privileges.
- The Active Directory module must be installed on the system.
- The script validates the input CSV path and ensures the domain matches FQDN format.

.LINK
https://github.com/Michael-Free/CreateADUsers/blob/main/README.md

#>
param(
  [Parameter(Mandatory = $true)]
  [string]$CsvPath,
  [Parameter(Mandatory = $true)]
  [string]$Domain
)

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal($currentUser)

if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  throw 'Must be administrative user.'
}

$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem

if (-not ($osInfo.ProductType -eq 2 -or $osInfo.ProductType -eq 3)) {
  throw 'This system is not running Windows Server.'
}

if (-not (Test-Path -Path $CsvPath -PathType Leaf)) {
  throw "The specified file '$CsvPath' does not exist."
}

$fqdnRegex = '^(?=.{1,255}$)([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$'

if ($Domain -notmatch $fqdnRegex) {
  throw "Domain Name doesn't match FQDN format"
}

$dnParts = $Domain -split '\.' | ForEach-Object { "DC=$_" }
$domainName = $dnParts -join ','
$fullPath = "CN=Users,$domainName"

if (-not $((Get-Module).Name | Where-Object { $_ -eq 'ActiveDirectory' })) {
  try {
    Install-Module -Name 'ActiveDirectory' -Force
  }
  catch {
    throw 'Error installing ActiveDirectory Module'
  }
}

Import-Module -Name ActiveDirectory

$failedUsers = @()

Import-Csv $CsvPath  | ForEach-Object {
  $securePassword = $_.AccountPassword | ConvertTo-SecureString -AsPlainText -Force
  $splat = @{
    Name                  = $_.DisplayName
    SamAccountName        = $_.SamAccountName
    DisplayName           = $_.DisplayName
    UserPrincipalName     = "$($_.SamAccountName)@$domainName"
    EmailAddress          = $_.EmailAddress
    Company               = $_.Company
    Department            = $_.Department
    City                  = $_.City
    State                 = $_.State
    Country               = $_.Country
    Office                = $_.Office
    Description           = $_.Description
    Title                 = $_.Title
    GivenName             = $_.Name
    Surname               = $_.Surname
    AccountPassword       = $securePassword
    Enabled               = [bool](Get-Random -Minimum 0 -Maximum 2)
    Path                  = $fullPath
    ChangePasswordAtLogon = $false
  }

  try {
    New-ADUser @splat
  }
  catch {
    $failedUsers.Add($splat)
  }
}

