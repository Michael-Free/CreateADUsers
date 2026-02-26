<#
.SYNOPSIS
Generates a specified number of unique random user objects for Active Directory user creation.

.DESCRIPTION
The New-RandomUsersToCreate function generates a specified quantity of unique random user objects by calling Get-RandomUserData. It automatically handles duplicate SamAccountName values that may occur during random generation by detecting and replacing duplicates with new unique users until the requested amount is achieved. This ensures that all generated users have unique SamAccountName values suitable for Active Directory creation.

.PARAMETER Amount
Specifies the number of unique random user objects to generate. This parameter is mandatory and must be an integer greater than or equal to 1.

.INPUTS
System.Int32
You can pipe an integer value to this function representing the number of users to generate.

.OUTPUTS
System.Management.Automation.PSCustomObject[]
Returns an array of PSCustomObject objects, each containing random user data with unique SamAccountName values. Each object includes properties such as Name, Surname, DisplayName, SamAccountName, Title, Department, City, State, Country, Office, and AccountPassword.

.EXAMPLE
New-RandomUsersToCreate -Amount 5

Generates 5 unique random user objects.

.EXAMPLE
$users = New-RandomUsersToCreate -Amount 25
$users | Export-Csv -Path "bulk_users.csv" -NoTypeInformation

Generates 25 unique users and exports them to a CSV file for bulk import into Active Directory.

.NOTES
Author: Michael Free
Date Created: February 23, 2024
Module Name: CreateADUsers

This function performs duplicate detection and resolution:
1. Initially generates the requested number of users using Get-RandomUserData
2. Checks for duplicate SamAccountName values (generated from first initial + last name)
3. Counts and removes any duplicates found
4. Continues generating additional unique users until the requested amount is reached
5. Returns only users with unique SamAccountName values

This ensures that all generated users can be successfully created in Active Directory without naming conflicts.
The function maintains data integrity by preserving the first instance of any duplicate and regenerating replacements for subsequent duplicates.
#>
function New-RandomUsersToCreate {
  param(
    [Parameter(Mandatory = $true)]
    [int]$Amount
  )
  if (-not $Amount -ge 1) {
    throw 'Amount must be at least greater than or equal to 1'
  }
  $userDataArray = @()
  for ($i = 0; $i -lt $Amount; $i++) {
    $userDataArray += Get-RandomUserData
  }
  $uniqueUsers = @{}
  $duplicateCount = 0
  foreach ($user in $userDataArray) {
    $samAccountName = $user.samaccountname
    if (-not $uniqueUsers.ContainsKey($samAccountName)) {
      $uniqueUsers[$samAccountName] = $user
    }
    else {
      $duplicateCount++
    }
  }
  $userDataArray = $uniqueUsers.Values
  #$newAmount = $Amount - $duplicateCount
  while ($userDataArray.Count -lt $Amount) {
    $newUser = Get-RandomUserData
    $samAccountName = $newUser.samaccountname
    if (-not $uniqueUsers.ContainsKey($samAccountName)) {
      $uniqueUsers[$samAccountName] = $newUser
      $userDataArray = $uniqueUsers.Values
    }
  }
  return $userDataArray
}
