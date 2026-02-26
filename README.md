# CreateADUsers Powershell Module

**CreateADUsers** is a powerful framework generating and deploying test user data in an Active Directory environment.

## Breaking Change Notice

**After v1.1.0 the format of this has completely changed**

* Any version after v1.1.0 has completely done away with python, binaries, and more.
* New versions are completely PowerShell native.
* New versions are required to be ran directly on a Windows Server Domain Controller
* New versions require Powershell 7 or higher.
* New versions after v1.1.0 are now a dedicate powershell module as opposed to a series of scripts to be ran.

## Usage

Creating **test users** in **Active Directory** can be tedious. **CreateADUsers** is a PowerShell module that automates it, generating realistic accounts in seconds with a single command. **Test accounts** are created with names, departments, job titles, compliant passwords, and almost all necessary AD attributes.

Each account is logged with username, password, and more, so you can start testing immediately. Whether you need a handful of users for permissions testing or hundreds to stress-test Group Policy, it’s all done instantly.

Perfect for homelabs, test environments, or spinning up a new Domain Controller without the baggage of importing old user data.

## Features
- Auto-incrementing account names to prevent duplicates (jsmith, jsmith1, jsmith2)
- Realistic user data generation (names, departments, job titles)
- Password complexity compliance (16+ chars with uppercase, lowercase, numbers, special)
- Comprehensive error handling and logging
- Domain environment validation before user creation

## Installation

### From PowerShell Gallery

```powershell
Install-Module -Name CreateADUsers
```

### Import the Module

```powershell
Import-Module -Name CreateADUsers
```

## Key Functions

### Create New Test Users

```powershell
New-TestADUser -Amount 10
```

This creates 10 new Active Directory users. Each new user created is unique and extra care is taken to make sure 10 new users are created and don't overlap with any existing Active Directory user accounts.

New user accounts are created with first initial of the first name with the last name added as a suffix. This means that `John Smith` will have the account name `jsmith`.

If another new user is created that is `Jane Smith`, their account name would also be `jsmith`, but to account for this it auto-increments the account name and `Jane Smith` with `jsmith1`, or `jsmith2` (if there is already a `jsmith1` account).

In the directory that this is command is ran from, there will be a log file created that details the username and password required for each new user added to Active Directory. This is useful for when accounts need to be tested. The log file will start with `NewTestADUSers-<TIMESTAMP>.txt`

## Requirements

* PowerShell Core 7+
* Windows Server 2016+
* Active Directory and Domain Controller role installed
* Administrative Privileges
* FreeLog PowerShell Module
* ActiveDirectory Powershell Module

## Module Information

- Version: v2.0.26
- Author: Michael Free
- License: See LICENSE file
- Project URL: https://github.com/Michael-Free/CreateADUsers

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the terms included in the LICENSE file.

This is using the Free Custom License (FCL v1.0)

## Disclaimer

This module is provided as-is with no warranty.


