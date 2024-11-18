<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.EXAMPLE

.INPUTS

.OUTPUTS

.NOTES

.LINK

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

