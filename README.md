# git-sight
GitHub Activity BigData Analysis

GitHub is a huge platform where developers work together and share open-source projects.
By using big data tools, we can find useful patterns like:

Who the most active or influential developers are
What tools and technologies are becoming popular
How different developer communities grow and change over time
These insights are helpful for:

Developers to learn and grow
Companies to spot trends and talent
Researchers to understand tech communities better


# Overview
This project reads a large data.json file containing user data, and splits important array fields into separate Excel files.
It extracts information from:

repo_list
commit_list
follower_list
following_list
Each array is flattened and saved as a separate Excel file for easier analysis.


# How It Works

Open and read the data.json line-by-line.

Extract login and id for each user.

Expand each array (repo_list, commit_list, etc.) into flat tables.

Save each table separately as:
repo_list.xlsx
commit_list.xlsx
follower_list.xlsx
following_list.xlsx

The Python script handles errors safely and ensures clean data extraction.

# How to Run

Install Python 3.x
Install necessary libraries:
Run-
pip install pandas openpyxl


