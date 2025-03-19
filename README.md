# CreateADUsers

Prerequisites

Installation

## Usage

### createusers.py

This script creates random users and their associated data, including a SamAccountName, email address, and password. The script 
can be run with any number of users as an argument, and will create that many users in a CSV file called "random_users.csv". The 
script uses the Faker library to generate fake data for each user, and the random module to randomly select a department and 
office location.

#### Dependencies
The script requires the following dependencies:

- faker
- random
- sys
- os
- string

#### Example
To use this script, simply run it with an integer as an argument representing the number of users you want to create. For 
example, to create 10 users, you can run the script as follows:

```bash
python3 createusers.py 10
```

The script will create a CSV file called "random_users.csv" in the current working directory, containing the generated user data. 
You can open this file using a spreadsheet program or other tool to view and manipulate the data.

### addusers.ps1
This PowerShell script automates the creation of Active Directory (AD) user accounts from a CSV file. It ensures the script is executed with administrative privileges and on a Windows Server system before proceeding. The script validates the provided domain name and CSV file, then imports user data to create AD accounts with the specified attributes.

#### Dependencies

- Windows Server 
- Administrative Privileges
- Active Directory Module for PowerShell
- Domain-Joined Machine
- PowerShell 5.1 or newer

#### Example

```bash
.\addusers.ps1 -CsvPath "C:\path\to\random_users.csv" -Domain "example.com"
```

If successful:

```
All users created successfully!
```

If some users fail to create:
```
Some users failed to create:
User       Error
----       -----
jsmith     The specified user already exists
```

## License

BSD 3-Clause License

Copyright (c) 2025, Michael Free

## Contributions

### Reporting Bugs

If you encounter any issues while using the tool, please report them in the issue tracker on GitHub. Be sure to include the following information in your bug report:

    - The steps to reproduce the issue
    - The expected behavior
    - The actual behavior
    - Any error messages or stack traces associated with the issue

### Requesting Features

If you have an idea for a new feature, please let me know by creating an issue in the issue tracker on GitHub. Be sure to explain why this feature would be useful and how it could benefit the project.

### Contributing Code

If you're a developer interested in contributing code to the project, I encourage you to submit a pull request through GitHub. Before submitting your code, please make sure it adheres to my coding standards and passes any automated tests.

### Providing Feedback

Your feedback is valuable to me. If you have any suggestions or ideas for improving the tool, please share them with me through the issue tracker on GitHub or by reaching out to me on Mastodon: https://mastodon.social/@MichaelFree

### Testing and Quality Assurance

I appreciate any help testing the project and reporting issues. If you have experience in testing, please let me know by creating an issue in the issue tracker on GitHub or by contacting me directly.

Thank you for your interest in contributing to my project! Your contributions will help make it even better.

