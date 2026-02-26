<#
.SYNOPSIS
Generates random user data for creating test Active Directory users.

.DESCRIPTION
The Get-RandomUserData function generates comprehensive random user information suitable for creating test or demonstration Active Directory users. It creates realistic user data including names, job titles, departments, office locations, and secure passwords. The function randomly selects from extensive lists of first names, last names, departments with associated job titles, and office locations to ensure variety in generated user data.

.PARAMETER None
This function does not accept any parameters.

.INPUTS
None. This function does not accept pipeline input..

.OUTPUTS
System.Management.Automation.PSCustomObject
Returns a custom object containing the following properties for a randomly generated user:
- Name: Random first name
- Surname: Random last name
- DisplayName: Combined first and last name
- SamAccountName: Generated from first initial + last name (lowercase)
- Title: Random job title from a randomly selected department
- Department: Department name associated with the job title
- City: Office city location
- State: Office state/province
- Country: Two-letter country code
- Office: Descriptive office name
- AccountPassword: Randomly generated secure password (minimum 16 characters)

.EXAMPLE
Get-RandomUserData

Generates a single random user with all properties populated from the available data sets.

.NOTES
Author: Michael Free
Date Created: February 23, 2024
Module Name: CreateADUsers

This function generates passwords that:
- Are at least 16 characters long
- Include at least one uppercase letter, one lowercase letter, one number, and one special character
- Are randomly generated using ASCII character ranges

The SamAccountName is generated using the pattern: first initial + last name (e.g., jsmith)
All generated passwords are returned as plain text strings for immediate use in user creation.
#>
function Get-RandomUserData {
  $names = @{
    FirstNames = @(
      'James', 'John', 'Robert', 'Michael', 'William', 'David', 'Richard', 'Joseph', 'Thomas', 'Charles',
      'Christopher', 'Daniel', 'Matthew', 'Anthony', 'Donald', 'Mark', 'Paul', 'Steven', 'Andrew', 'Kenneth',
      'Joshua', 'Kevin', 'Brian', 'George', 'Edward', 'Ronald', 'Timothy', 'Jason', 'Jeffrey', 'Ryan',
      'Jacob', 'Gary', 'Nicholas', 'Eric', 'Jonathan', 'Stephen', 'Larry', 'Justin', 'Scott', 'Brandon',
      'Benjamin', 'Samuel', 'Gregory', 'Frank', 'Alexander', 'Raymond', 'Patrick', 'Jack', 'Dennis', 'Jerry',
      'Tyler', 'Aaron', 'Jose', 'Henry', 'Adam', 'Douglas', 'Nathan', 'Peter', 'Zachary', 'Kyle',
      'Walter', 'Harold', 'Jeremy', 'Ethan', 'Carl', 'Keith', 'Roger', 'Gerald', 'Christian', 'Terry',
      'Sean', 'Arthur', 'Austin', 'Noah', 'Lawrence', 'Jesse', 'Joe', 'Bryan', 'Billy', 'Jordan',
      'Albert', 'Dylan', 'Bruce', 'Willie', 'Gabriel', 'Alan', 'Juan', 'Logan', 'Wayne', 'Ralph',
      'Roy', 'Eugene', 'Randy', 'Vincent', 'Russell', 'Elijah', 'Louis', 'Bobby', 'Philip', 'Johnny',
      'Mary', 'Patricia', 'Jennifer', 'Linda', 'Elizabeth', 'Barbara', 'Susan', 'Jessica', 'Sarah', 'Karen',
      'Nancy', 'Lisa', 'Betty', 'Margaret', 'Sandra', 'Ashley', 'Kimberly', 'Emily', 'Donna', 'Michelle',
      'Dorothy', 'Carol', 'Amanda', 'Melissa', 'Deborah', 'Stephanie', 'Rebecca', 'Sharon', 'Laura', 'Cynthia',
      'Kathleen', 'Amy', 'Shirley', 'Angela', 'Helen', 'Anna', 'Brenda', 'Pamela', 'Nicole', 'Emma',
      'Samantha', 'Katherine', 'Christine', 'Debra', 'Rachel', 'Carolyn', 'Janet', 'Catherine', 'Maria', 'Heather',
      'Diane', 'Ruth', 'Julie', 'Olivia', 'Joyce', 'Virginia', 'Victoria', 'Kelly', 'Lauren', 'Christina',
      'Joan', 'Evelyn', 'Judith', 'Megan', 'Andrea', 'Cheryl', 'Hannah', 'Jacqueline', 'Martha', 'Gloria',
      'Teresa', 'Ann', 'Sara', 'Madison', 'Frances', 'Kathryn', 'Janice', 'Jean', 'Abigail', 'Alice',
      'Julia', 'Judy', 'Sophia', 'Grace', 'Denise', 'Amber', 'Doris', 'Marilyn', 'Danielle', 'Beverly',
      'Isabella', 'Theresa', 'Diana', 'Natalie', 'Brittany', 'Charlotte', 'Marie', 'Kayla', 'Alexis', 'Lori'
    )

    LastNames  = @(
      'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis', 'Garcia', 'Rodriguez', 'Martinez',
      'Wilson', 'Anderson', 'Taylor', 'Thomas', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson',
      'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson', 'Walker', 'Young', 'Allen',
      'King', 'Wright', 'Scott', 'Torres', 'Hill', 'Flores', 'Green', 'Adams', 'Nelson', 'Baker',
      'Hall', 'Rivera', 'Campbell', 'Mitchell', 'Carter', 'Roberts', 'Gomez', 'Phillips', 'Evans', 'Turner',
      'Diaz', 'Parker', 'Cruz', 'Edwards', 'Collins', 'Reyes', 'Stewart', 'Morris', 'Morales', 'Murphy',
      'Cook', 'Rogers', 'Gutierrez', 'Ortiz', 'Morgan', 'Cooper', 'Peterson', 'Bailey', 'Reed', 'Kelly',
      'Howard', 'Ramos', 'Kim', 'Cox', 'Ward', 'Richardson', 'Watson', 'Brooks', 'Chavez', 'Wood',
      'James', 'Bennett', 'Gray', 'Mendoza', 'Ruiz', 'Hughes', 'Price', 'Alvarez', 'Castillo', 'Sanders',
      'Patel', 'Myers', 'Long', 'Ross', 'Foster', 'Jimenez', 'Powell', 'Jenkins', 'Perry', 'Russell',
      'Sullivan', 'Bell', 'Coleman', 'Butler', 'Henderson', 'Barnes', 'Gonzales', 'Fisher', 'Vasquez', 'Simmons',
      'Romero', 'Jordan', 'Patterson', 'Alexander', 'Hamilton', 'Graham', 'Reynolds', 'Griffin', 'Wallace', 'Moreno',
      'West', 'Cole', 'Hayes', 'Bryant', 'Hererra', 'Gibson', 'Ellis', 'Medina', 'Aguilar', 'Stevens',
      'Murray', 'Ford', 'Castro', 'Marshall', 'Owens', 'Harrison', 'Fernandez', 'McDonald', 'Woods', 'Washington',
      'Kennedy', 'Wells', 'Vargas', 'Henry', 'Freeman', 'Webb', 'Tucker', 'Guzman', 'Burns', 'Crawford',
      'Muller', 'Schmidt', 'Schneider', 'Fischer', 'Weber', 'Meyer', 'Wagner', 'Becker', 'Schulz', 'Hoffmann',
      'Schafer', 'Koch', 'Bauer', 'Richter', 'Klein', 'Wolf', 'Schroder', 'Neumann', 'Schwarz', 'Zimmermann',
      'Braun', 'Kruger', 'Hofmann', 'Hartmann', 'Lange', 'Schmitt', 'Werner', 'Schmitz', 'Krause', 'Meier',
      'Lehmann', 'Schmid', 'Schulze', 'Maier', 'Kohler', 'Herrmann', 'Konig', 'Walter', 'Mayer', 'Huber',
      'Kaiser', 'Fuchs', 'Peters', 'Lang', 'Scholz', 'Moller', 'Weiss', 'Jung', 'Hahn', 'Schubert',
      'Vogel', 'Friedrich', 'Keller', 'Gunther', 'Frank', 'Berger', 'Winkler', 'Roth', 'Beck', 'Lorenz',
      'Baumann', 'Franke', 'Albrecht', 'Schuster', 'Simon', 'Ludwig', 'Bohm', 'Winter', 'Kraus', 'Martin',
      'Schumacher', 'Kramer', 'Vogt', 'Stein', 'Jager', 'Otto', 'Zimmer', 'Sommer', 'Gross', 'Seidel',
      'Heinrich', 'Brandt', 'Haas', 'Schreiber', 'Graf', 'Schulte', 'Dietrich', 'Ziegler', 'Kuhn', 'Pohl',
      'Engel', 'Horn', 'Busch', 'Bergmann', 'Thomas', 'Sauer', 'Arnold', 'Wolff', 'Pfeiffer', 'Michel',
      'Seifert', 'Hempel', 'Bayer', 'Geiger', 'Stark', 'Wenzel', 'Steiner', 'Wild', 'Kern', 'Vetter',
      'Adler', 'Bender', 'Witt', 'Brinkmann', 'Ebert', 'Wegner', 'Bachmann', 'Thiel', 'Wendt', 'Stoll',
      'Riedel', 'Rohde', 'Frey', 'Keil', 'Nagel', 'Strauss', 'Buttner', 'Fritsch', 'Bock', 'Lenz',
      'Bartsch', 'Kurz', 'Heinz', 'Urban', 'Schilling', 'Bischoff', 'Ernst', 'Fink', 'Henning', 'Ritter',
      'Haase', 'Lauer', 'Mertz', 'Mohr', 'Pfeffer', 'Fleischer', 'Schramm', 'Wirth', 'Heine', 'Burkhardt',
      'Martin', 'Bernard', 'Dubois', 'Thomas', 'Robert', 'Richard', 'Petit', 'Durand', 'Leroy', 'Moreau',
      'Simon', 'Laurent', 'Lefebvre', 'Michel', 'Garcia', 'David', 'Bertrand', 'Roux', 'Vincent', 'Fournier',
      'Morel', 'Girard', 'Andre', 'Lefevre', 'Mercier', 'Dupont', 'Lambert', 'Bonnet', 'Francois', 'Martinez',
      'Legrand', 'Garnier', 'Faure', 'Rousseau', 'Blanc', 'Guerin', 'Muller', 'Henry', 'Roussel', 'Nicolas',
      'Perrin', 'Morin', 'Mathieu', 'Clement', 'Gauthier', 'Dumont', 'Lopez', 'Fontaine', 'Chevalier', 'Robin',
      'Masson', 'Sanchez', 'Gerard', 'Nguyen', 'Boyer', 'Denis', 'Lemaire', 'Duval', 'Joly', 'Gautier',
      'Roger', 'Pascal', 'Fabre', 'Leroux', 'David', 'Carre', 'Rolland', 'Leclercq', 'Benoit', 'Rey',
      'Brun', 'Legendre', 'Gaillard', 'Lacroix', 'Philippe', 'Aubert', 'Roy', 'Marchand', 'Dumas', 'Colin',
      'Chauvin', 'Laporte', 'Meyer', 'Huet', 'Perrot', 'Renaud', 'Caron', 'Barre', 'Lejeune', 'Guillot',
      'Fleury', 'Marin', 'Parisot', 'Berger', 'Valentin', 'Gilles', 'Roche', 'Bailly', 'Picard', 'Charpentier'
    )
  }
  $offices = @(
    [PSCustomObject]@{
      city        = 'Waterloo'
      state       = 'Ontario'
      country     = 'CA'
      office_name = 'Headquarters'
    },
    [PSCustomObject]@{
      city        = 'San Francisco'
      state       = 'CA'
      country     = 'USA'
      office_name = 'West Coast Office'
    },
    [PSCustomObject]@{
      city        = 'London'
      state       = 'N/A'
      country     = 'GB'
      office_name = 'European Office'
    }
  )

  $departments = @(
    [PSCustomObject]@{
      name       = 'Marketing'
      job_titles = @(
        'Marketing Manager',
        'Content Strategist',
        'Social Media Coordinator',
        'SEO Specialist',
        'Graphic Designer'
      )
    },
    [PSCustomObject]@{
      name       = 'Human Resources'
      job_titles = @(
        'HR Manager',
        'Recruiter',
        'HR Specialist',
        'Training Coordinator',
        'Compensation Analyst'
      )
    },
    [PSCustomObject]@{
      name       = 'Facilities'
      job_titles = @(
        'Facilities Manager',
        'Maintenance Technician',
        'Custodial Supervisor',
        'Security Officer',
        'Environmental Health Specialist'
      )
    },
    [PSCustomObject]@{
      name       = 'Accounting'
      job_titles = @(
        'Accountant',
        'Accounts Payable Clerk',
        'Accounts Receivable Specialist',
        'Financial Analyst',
        'Payroll Coordinator'
      )
    },
    [PSCustomObject]@{
      name       = 'IT'
      job_titles = @(
        'IT Support Specialist',
        'Network Administrator',
        'Systems Analyst',
        'Cybersecurity Specialist',
        'Database Administrator'
      )
    },
    [PSCustomObject]@{
      name       = 'Development'
      job_titles = @(
        'Software Developer',
        'Frontend Developer',
        'Backend Developer',
        'DevOps Engineer',
        'Quality Assurance Analyst'
      )
    },
    [PSCustomObject]@{
      name       = 'Sales'
      job_titles = @(
        'Sales Manager',
        'Account Executive',
        'Sales Representative',
        'Business Development Manager',
        'Sales Operations Coordinator'
      )
    }
  )

  $randomDept = $departments | Get-Random
  $randomJobTitle = $randomDept.job_titles | Get-Random
  $randomOffice = $offices | Get-Random
  $randomFirstName = $names.FirstNames | Get-Random
  $randomLastName = $names.LastNames | Get-Random
  $displayName = $randomFirstName + ' ' + $randomLastName
  $samAccountName = $randomFirstName[0] + $randomLastName
  # https://www.reddit.com/r/PowerShell/comments/17wz2xh/powershell_generate_random_password/
  $upperCase = (65..90)
  $lowerCase = (97..122)
  $numbers = (48..57)
  $specialChars = @(33, 35, 36, 37, 38, 42, 43, 45, 61, 63, 64)
  $allChars = $upperCase + $lowerCase + $numbers + $specialChars
  do {
    $passwordChars = @()
    $passwordChars += [char](Get-Random $upperCase)
    $passwordChars += [char](Get-Random $lowerCase)
    $passwordChars += [char](Get-Random $numbers)
    $passwordChars += [char](Get-Random $specialChars)
    $passwordChars += 1..12 | ForEach-Object {
      [char](Get-Random $allChars)
    }
    $accountPassword = -join ($passwordChars | Get-Random -Count $passwordChars.Count)

  }
  until ($accountPassword.Length -ge 16)

  return [PSCustomObject]@{
    Name            = [string]$randomFirstName
    Surname         = [string]$randomLastName
    DisplayName     = [string]$displayName
    SamAccountName  = [string]$samAccountName.ToLower()
    Title           = [string]$randomJobTitle
    Department      = [string]$randomDept.Name
    City            = [string]$randomOffice.City
    State           = [string]$randomOffice.State
    Country         = [string]$randomOffice.Country
    Office          = [string]$randomOffice.office_name
    AccountPassword = $accountPassword
  }
}

