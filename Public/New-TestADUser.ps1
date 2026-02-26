<#
.SYNOPSIS
Creates multiple test Active Directory users with unique random data and comprehensive logging.

.DESCRIPTION
The New-TestADUser function automates the creation of test users in Active Directory. It performs comprehensive pre-validation of the environment (PowerShell version, operating system, domain controller status), generates unique random user data, resolves naming conflicts with existing AD users, adds required AD properties, and creates the users with detailed logging. The function automatically handles duplicate SamAccountName values by appending incremental numbers and generates a log file with user credentials.

.PARAMETER Amount
Specifies the number of test Active Directory users to create. This parameter is mandatory and must be an integer greater than or equal to 1.

.INPUTS
System.Int32
You can pipe an integer value to this function representing the number of test users to create.

.OUTPUTS
None. This function does not return objects to the pipeline. Instead, it creates users in Active Directory and generates a log file with creation details.

.EXAMPLE
New-TestADUser -Amount 50
Get-Content -Path .\NewTestADUsers-*.txt

Creates 50 test users and then displays the most recent log file containing usernames and passwords.

.NOTES
Author: Michael Free
Date Created: February 23, 2024
Module Name: CreateADUsers

This function performs the following operations in sequence:
1. Validates PowerShell version is 7 or higher
2. Validates operating system is Windows Server domain controller
3. Generates the requested number of unique random user objects
4. Checks for SamAccountName conflicts with existing AD users
5. Resolves conflicts by appending incremental numbers (e.g., jsmith, jsmith1, jsmith2)
6. Adds required AD properties (Company, EmailAddress, Path, Enabled, ChangePasswordAtLogon)
7. Creates a timestamped log file in the current directory
8. Creates each user in Active Directory with comprehensive error handling
9. Logs successful creations with passwords and failed attempts with error details.

Log File Format:
- Filename: NewTestADUsers-DD-MM-YYYY-HH.mm.ss.txt
- Success entries: "Created username - Password: password"
- Failure entries: "Failed to create username - [JSON data] - Error: error message"

The function requires the Active Directory PowerShell module and appropriate permissions to create users in the domain.
#>
function New-TestADUser {
    # Adding this rule for PSScriptAnalyzer, since this is a test user scenario that isn't meant for production.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
    # Addin this rule for PSScriptAnalyzer - this is a test-only environment.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param(
        [Parameter(Mandatory=$true)]
        [int]$Amount
    )
    if (-not $Amount -ge 1) {
        throw "Amount must be at least greater than or equal to 1."
    }
    try {
        Get-PowershellVersionStatus | Out-Null
        Get-OperatingSystemType | Out-Null
    }
    catch {
        throw "$_"
    }
    # Generate a bunch of new, unique users
    $newUniqueUsers = New-RandomUsersToCreate -Amount $Amount
    try {
        # Get the users currently in active directory
        $currentADUsers = Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName
        $userstoadd = @()
        foreach ($user in $newUniqueUsers) {
            $baseName = $user.SamAccountName
            $finalName = $baseName
            $counter = 1

            # Check if name exists in AD
            while (($finalName -in $currentADUsers)) {
                # Remove numbers from the end of the username
                $finalName = $finalName -replace '\d+$', ''
                # Add a number to to the end of the user name
                $finalName = "$baseName$counter"
                # Add one more to the counter
                $counter++
                # Loop through until account name longer matches
            }
            # Change the object value for account name
            $user.SamAccountName = $finalName
            # Add the user object to the users to add array
            $userstoadd += $user
        }

        # Get domain controller information
        $domainControllerInfo = Get-DomainControllerStatus

        # Add properties to each user object for the sake of completing a user profile
        foreach ($user in $userstoadd){
            $user | Add-Member -NotePropertyName "Company" -NotePropertyValue $domainControllerInfo.BiosName
            $emailAddress = $user.SamAccountName + "@" + $domainControllerInfo.Fqdn
            $user | Add-Member -NotePropertyName "EmailAddress" -NotePropertyValue $emailAddress
            $user | Add-Member -NotePropertyName "Path" -NotePropertyValue $domainControllerInfo.UserCont
            $user | Add-Member -NotePropertyName "Enabled" -NotePropertyValue $true
            $user | Add-Member -NotePropertyName "ChangePasswordAtLogon" -NotePropertyValue $true
        }

    }
    catch {
        throw "AD connection error: $_"
    }
    $LogfilePath = Join-Path -Path (Get-Location).Path -ChildPath "NewTestADUsers-$(Get-Date -Format "dd-MM-yyyy-HH.mm.ss").txt"
    New-LogFile -Path $LogfilePath
    foreach ($user in $userstoadd) {
        $splat = @{
            Name                  = $user.SamAccountName
            SamAccountName        = $user.SamAccountName
            DisplayName           = $user.DisplayName
            EmailAddress          = $user.EmailAddress
            Company               = $user.Company
            Department            = $user.Department
            City                  = $user.City
            State                 = $user.State
            Country               = $user.Country
            Office                = $user.Office
            Title                 = $user.Title
            Surname               = $user.Surname
            AccountPassword       = ConvertTo-SecureString -String $user.AccountPassword -AsPlainText -Force
            Enabled               = $user.Enabled
            Path                  = $user.Path
            ChangePasswordAtLogon = $user.ChangePasswordAtLogon
        }
        try {
            New-ADUser @splat
            Write-LogFile -TaskMessage "Created $($user.SamAccountName) - Password: $($user.AccountPassword)"
        }
        catch {
            $splatClone = $splat.Clone()
            if ($splatClone.AccountPassword) {
                $splatClone.AccountPassword = $user.AccountPassword
            }
            $json = $splatClone | ConvertTo-Json -Depth 3
            Write-LogFile -TaskFail "Failed to create $($user.SamAccountName) - $json - Error: $($_.Exception.Message)" -Verbose
        }
    }
}
