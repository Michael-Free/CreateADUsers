"""
Author:
    Michael Free (c) 2024

Description:
    This script generates a list of random user profiles for a fictional company.
    It is meant to be used for the creation of user profiles for a test Microsoft
    Active Directory/Domain Controller service.  

    This is so that someone can quickly generate profiles and import them into AD 
    so that they can begin working on test Group Policies without breaking their
    production environments.

    The script creates user data by randomly selecting departments, job titles, 
    and office locations.  
    
    The departments are based around common departments a person would encounter
    in most technology-based organizations. The departments also have job-titles
    that are fitting to each department.

    This script also generates random first and last names, as well as emails
    based on the company and domain name generated by it.  A random password is
    also generated for each user.

    The generated user data is stored in a list, which is then written to a CSV
    file named 'random_users.csv' for importing later by a powershell script.
    This file is generated in whatever directory the script is stored in.

    This script takes an integer argument specifying the number of users to 
    generate and ensures that no two users have the same SamAccountName. This 
    makes sure that there are no issues when bulk importing these accounts.

Dependencies:
    - `faker`: A library to generate random names and sentences.
    - `random`: Used for generating random job titles, office locations, and password components.
    - `string`: For generating password characters.
    - `os`: Used for file operations (checking and removing the existing CSV file).

Copyright & License:
  Author      : Michael Free
  Date        : 2025-03-19
  License     : Free Custom License (FCL) v1.0
  Copyright   : 2025, Michael Free. All Rights Reserved.
  Requires    : Active Directory module
"""
import sys
import random
import string
import os
from faker import Faker

fake = Faker()


def create_user(fcompany, fdomainname):
    """
    Generate a random user profile with specified company and domain name.

    This function creates a random user profile by selecting a department, 
    job title, office location, and generating random first and last names.

    It then constructs a dictionary representing the user's details including 
    their account name, email, title, department, company, office location, 
    and a randomly generated password.

    Parameters:
        fcompany (str): The name of the company to associate with the user.
        fdomainname (str): The domain name to use for the user's email address.

    Returns:
        dict: A dictionary containing the user's generated details such as 
              name, email address, job title, department, company, office location, 
              and a generated password.

    Example:
    >>> create_user("TechCorp", "techcorp.com")
    {
        'Name': 'John',
        'Surname': 'Doe',
        'DisplayName': 'John Doe',
        'SamAccountName': 'jdoe',
        'EmailAddress': 'jdoe@techcorp.com',
        'Title': 'Software Developer',
        'Department': 'Development',
        'Company': 'TechCorp',
        'City': 'San Francisco',
        'State': 'CA',
        'Country': 'USA',
        'Office': 'West Coast Office',
        'Description': 'Lorem ipsum dolor sit amet.',
        'AccountPassword': 'aB7dEf4G!'
    }
    """
    departments = [
        {
            "name": "Marketing",
            "job_titles": [
                "Marketing Manager",
                "Content Strategist",
                "Social Media Coordinator",
                "SEO Specialist",
                "Graphic Designer",
            ],
        },
        {
            "name": "Human Resources",
            "job_titles": [
                "HR Manager",
                "Recruiter",
                "HR Specialist",
                "Training Coordinator",
                "Compensation Analyst",
            ],
        },
        {
            "name": "Facilities",
            "job_titles": [
                "Facilities Manager",
                "Maintenance Technician",
                "Custodial Supervisor",
                "Security Officer",
                "Environmental Health Specialist",
            ],
        },
        {
            "name": "Accounting",
            "job_titles": [
                "Accountant",
                "Accounts Payable Clerk",
                "Accounts Receivable Specialist",
                "Financial Analyst",
                "Payroll Coordinator",
            ],
        },
        {
            "name": "IT",
            "job_titles": [
                "IT Support Specialist",
                "Network Administrator",
                "Systems Analyst",
                "Cybersecurity Specialist",
                "Database Administrator",
            ],
        },
        {
            "name": "Development",
            "job_titles": [
                "Software Developer",
                "Frontend Developer",
                "Backend Developer",
                "DevOps Engineer",
                "Quality Assurance Analyst",
            ],
        },
        {
            "name": "Sales",
            "job_titles": [
                "Sales Manager",
                "Account Executive",
                "Sales Representative",
                "Business Development Manager",
                "Sales Operations Coordinator",
            ],
        },
    ]

    offices = [
        {
            "city": "Waterloo",
            "state": "Ontario",
            "country": "Canada",
            "office_name": "Headquarters",
        },
        {
            "city": "San Francisco",
            "state": "CA",
            "country": "USA",
            "office_name": "West Coast Office",
        },
        {
            "city": "London",
            "state": "N/A",
            "country": "UK",
            "office_name": "European Office",
        },
    ]

    random_character = "[!@#$%^&*()<>.]"
    random_department = random.choice(departments)

    user_office = random.choice(offices)
    user_firstname = fake.first_name()
    user_lastname = fake.last_name()
    user_accountname = (user_firstname[0] + user_lastname).lower()
    user_dict = {
        "Name": user_firstname,
        "Surname": user_lastname,
        "DisplayName": user_firstname + " " + user_lastname,
        "SamAccountName": user_accountname,
        "EmailAddress": user_accountname + "@" + fdomainname,
        "Title": random.choice(random_department["job_titles"]),  # fake.job(),
        "Department": random_department["name"],
        "Company": fcompany,
        "City": user_office["city"],
        "State": user_office["state"],
        "Country": user_office["country"],
        "Office": user_office["office_name"],
        "Description": fake.sentence(),
        "AccountPassword": "".join(random.sample(string.ascii_letters, 8))
        + "".join(random.sample(string.digits, 4))
        + random_character[random.randint(0, len(random_character) - 1)],
    }
    return user_dict


def samaccountname_exists(data, key, value):
    """
    Check if any dictionary in a list has a specific key-value pair.

    Iterates over a list of dictionaries (data) and checks 
    if any dictionary contains a specified key-value pair. It returns `True` 
    if a match is found, and `False` if not.

    Parameters:
        data (list): A list of dictionaries to search through.
        key (str): The key to look for in each dictionary.
        value (str): The value to match for the specified key.

    Returns:
        bool: True if found 
              otherwise False.
    """
    return any(d.get(key) == value for d in data)


if __name__ == "__main__":
    FAKE_COMPANY = (fake.company()).replace(",", "")
    # https://stackoverflow.com/questions/5843518/remove-all-special-characters-punctuation-and-spaces-from-string
    FAKE_DOMAINNAME = (
        "".join(e for e in FAKE_COMPANY if e.isalnum()) + str(".com")
    ).lower()

    try:
        users_to_create = int(sys.argv[1])
    except ValueError:
        print("Invalid input. Please enter a valid integer.")
        sys.exit(1)

    user_array = []

    for _ in range(users_to_create):
        new_user = create_user(FAKE_COMPANY, FAKE_DOMAINNAME)
        while samaccountname_exists(
            user_array, "SamAccountName", new_user["SamAccountName"]
        ):
            new_user = create_user(FAKE_COMPANY, FAKE_DOMAINNAME)
        user_array.append(create_user(FAKE_COMPANY, FAKE_DOMAINNAME))

    USER_CSV = "random_users.csv"

    if os.path.isfile(USER_CSV):
        os.remove(USER_CSV)

    with open(USER_CSV, "w", encoding="utf-8") as f:
        # https://www.scaler.com/topics/dict-to-csv-python/
        f.write(",".join(user_array[0].keys()))
        f.write("\n")
        for row in user_array:
            f.write(",".join(str(x) for x in row.values()))
            f.write("\n")
