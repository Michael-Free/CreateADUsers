<#
.SYNOPSIS
Gets the status and basic information of the current Active Directory domain.

.DESCRIPTION
The Get-DomainControllerStatus function retrieves essential information about the current Active Directory domain including the FQDN, NetBIOS name, distinguished name, and users container. This function requires the Active Directory module to be loaded and appropriate permissions to query Active Directory.

.PARAMETER None
This function does not accept any parameters.

.INPUTS
None. This function does not accept pipeline input.

.OUTPUTS
System.Management.Automation.PSCustomObject
Returns a custom object containing the following properties:
- Fqdn: The fully qualified domain name (DNS root)
- BiosName: The NetBIOS name of the domain
- DistName: The distinguished name of the domain
- UserCont: The distinguished name of the default users container

.EXAMPLE
Get-DomainControllerStatus

Retrieves the domain information for the current Active Directory domain.

.EXAMPLE
$domainInfo = Get-DomainControllerStatus
Write-Host "Domain FQDN: $($domainInfo.Fqdn)"

Gets the domain information and displays the FQDN.

.NOTES
Author: Michael Free
Date Created: February 23, 2024
Module Name: CreateADUsers

This function requires:
- Active Directory module for PowerShell
- Appropriate permissions to query Active Directory
- The computer must be joined to an Active Directory domain
#>
function Get-DomainControllerStatus {
  try {
    $domain = Get-ADDomain
    $domainInfo = [PSCustomObject]@{
      Fqdn     = $domain.DNSRoot
      BiosName = $domain.NetBIOSName
      DistName = $domain.DistinguishedName
      UserCont = $domain.UsersContainer
    }
  }
  catch {
    throw "Error getting domain info: $_"
  }
  return $domainInfo
}
