# Laptop-SQL-Case-Study
This repository contains an SQL script designed for managing a database of laptop specifications. The script handles tasks such as creating tables, migrating data, validating entries, and modifying table schemas to ensure data consistency and integrity.

Features

Data Retrieval: Queries to fetch data from the laptop_backup table.

Database Setup: Creates a new table laptop with the same structure as laptop_backup.

Data Migration: Transfers data from laptop_backup to laptop.

Data Validation: Identifies rows with null values across critical columns.

Schema Modification: Alters the Inches column to a decimal type for better precision.

SQL Configuration: Includes settings such as SQL_SAFE_UPDATES for controlled updates.

Prerequisites

A MySQL database instance.

A database named mydb with a table laptop_backup containing laptop specifications.

Script Overview

Select Data from Backup:

SELECT * FROM mydb.laptop_backup;

Retrieves all records from the laptop_backup table.

Create New Table:

CREATE TABLE laptop LIKE laptop_backup;

Creates a new table laptop with the same structure as laptop_backup.

Insert Data:

INSERT INTO laptop
SELECT * FROM laptop_backup;

Migrates data from laptop_backup to laptop.

Validate Data:

SELECT `Unnamed: 0` FROM laptop_backup
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL
AND Weight IS NULL AND Price IS NULL;

Identifies rows with null values in critical columns.

Modify Schema:

ALTER TABLE laptop_backup MODIFY COLUMN Inches DECIMAL(10,1);

Changes the Inches column to a decimal type for improved precision.

SQL Safe Updates:

SET SQL_SAFE_UPDATES = 0;

Temporarily disables safe updates to allow unrestricted modifications.

How to Use

Clone this repository:

git clone https://github.com/yourusername/laptop-database-management.git

Open the SQL script in your preferred SQL client.

Execute the script step by step or as a whole, depending on your requirements.

Verify the results by querying the laptop table.

Notes

Ensure you have a backup of your database before running the script.

Modify the database and table names as needed to match your setu
