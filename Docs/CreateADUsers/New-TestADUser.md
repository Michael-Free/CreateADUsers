---
document type: cmdlet
external help file: CreateADUsers-Help.xml
HelpUri: ''
Locale: en-US
Module Name: CreateADUsers
ms.date: 02/25/2026
PlatyPS schema version: 2024-05-01
title: New-TestADUser
---

# New-TestADUser

## SYNOPSIS

Creates multiple test Active Directory users with unique random data and comprehensive logging.

## SYNTAX

### __AllParameterSets

```
New-TestADUser [-Amount] <int> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The New-TestADUser function automates the creation of test users in Active Directory.
It performs comprehensive pre-validation of the environment (PowerShell version, operating system, domain controller status), generates unique random user data, resolves naming conflicts with existing AD users, adds required AD properties, and creates the users with detailed logging.
The function automatically handles duplicate SamAccountName values by appending incremental numbers and generates a log file with user credentials.

## EXAMPLES

### EXAMPLE 1

New-TestADUser -Amount 50
Get-Content -Path .\NewTestADUsers-*.txt

Creates 50 test users and then displays the most recent log file containing usernames and passwords.

## PARAMETERS

### -Amount

Specifies the number of test Active Directory users to create.
This parameter is mandatory and must be an integer greater than or equal to 1.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32
You can pipe an integer value to this function representing the number of test users to create.

{{ Fill in the Description }}

## OUTPUTS

### None. This function does not return objects to the pipeline. Instead

{{ Fill in the Description }}

## NOTES

Author: Michael Free
Date Created: February 23, 2024
Module Name: CreateADUsers

This function performs the following operations in sequence:
1.
Validates PowerShell version is 7 or higher
2.
Validates operating system is Windows Server domain controller
3.
Generates the requested number of unique random user objects
4.
Checks for SamAccountName conflicts with existing AD users
5.
Resolves conflicts by appending incremental numbers (e.g., jsmith, jsmith1, jsmith2)
6.
Adds required AD properties (Company, EmailAddress, Path, Enabled, ChangePasswordAtLogon)
7.
Creates a timestamped log file in the current directory
8.
Creates each user in Active Directory with comprehensive error handling
9.
Logs successful creations with passwords and failed attempts with error details

Log File Format:
- Filename: NewTestADUsers-DD-MM-YYYY-HH.mm.ss.txt
- Success entries: "Created username - Password: password"
- Failure entries: "Failed to create username - [JSON data] - Error: error message"

The function requires the Active Directory PowerShell module and appropriate permissions to create users in the domain.


## RELATED LINKS

{{ Fill in the related links here }}

