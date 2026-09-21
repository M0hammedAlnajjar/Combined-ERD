-- ============================================================
-- Company Task - Case Study
-- Full DDL Script for Microsoft SQL Server / SSMS
-- Source: Company_Case1_Mapping_With_Relationships(2).drawio
-- ============================================================

-- ============================================================
-- PART 1: Create Database
-- ============================================================

IF DB_ID('company_case_study_db') IS NULL
BEGIN
    CREATE DATABASE company_case_study_db;
END;
GO

USE company_case_study_db;
GO

-- ============================================================
-- PART 2: DEPARTMENT
-- Mapping:
-- DNUM PK
-- DName
-- Manager_SSN FK
-- Manager_Hire_Date
--
-- Manager_SSN is created first without its FK because EMPLOYEE
-- does not exist yet. The FK is added later with ALTER TABLE.
-- ============================================================

CREATE TABLE Department (
    DNUM INT IDENTITY(1,1),
    DName VARCHAR(100) NOT NULL,
    Manager_SSN VARCHAR(20) NULL,
    Manager_Hire_Date DATE NOT NULL,

    CONSTRAINT PK_Department
        PRIMARY KEY (DNUM),

    CONSTRAINT UQ_Department_Manager
        UNIQUE (Manager_SSN)
);
GO

-- ============================================================
-- PART 3: EMPLOYEE
-- Mapping:
-- SSN PK
-- Fname
-- Lname
-- Birth_Date
-- Gender
-- DNUM FK
-- Supervisor_SSN FK -> EMPLOYEE.SSN
--
-- DEPARTMENT 1:N EMPLOYEE
-- EMPLOYEE 1:N EMPLOYEE (SUPERVISES)
--
-- The mapping does not state Supervisor_SSN nullability.
-- It is left NULLABLE to allow a top-level employee/supervisor.
-- ============================================================

CREATE TABLE Employee (
    SSN VARCHAR(20) NOT NULL,
    Fname VARCHAR(100) NOT NULL,
    Lname VARCHAR(100) NOT NULL,
    Birth_Date DATE NOT NULL,
    Gender VARCHAR(20),
    DNUM INT NOT NULL,
    Supervisor_SSN VARCHAR(20) NULL,

    CONSTRAINT PK_Employee
        PRIMARY KEY (SSN),

    CONSTRAINT FK_Employee_Department
        FOREIGN KEY (DNUM)
        REFERENCES Department(DNUM),

    CONSTRAINT FK_Employee_Supervisor
        FOREIGN KEY (Supervisor_SSN)
        REFERENCES Employee(SSN)
);
GO

-- ============================================================
-- PART 4: Complete the MANAGES 1:1 relationship
-- EMPLOYEE 1:1 DEPARTMENT (MANAGES)
--
-- Manager_SSN references EMPLOYEE.SSN.
-- UNIQUE(Manager_SSN) in DEPARTMENT enforces that one employee
-- manages at most one department.
-- ============================================================

ALTER TABLE Department
ADD CONSTRAINT FK_Department_Manager
    FOREIGN KEY (Manager_SSN)
    REFERENCES Employee(SSN);
GO

-- The case says every Department always has one manager.
-- Since the tables are currently empty, we can enforce NOT NULL.
ALTER TABLE Department
ALTER COLUMN Manager_SSN VARCHAR(20) NOT NULL;
GO

-- ============================================================
-- PART 5: DEPARTMENT_LOCATIONS
-- DEPARTMENT 1:N DEPARTMENT_LOCATIONS
--
-- "locations" is a multivalued attribute, therefore it becomes
-- a separate table.
--
-- Composite PK: (DNUM, Location)
-- ============================================================

CREATE TABLE Department_Locations (
    DNUM INT NOT NULL,
    Location VARCHAR(150) NOT NULL,

    CONSTRAINT PK_Department_Locations
        PRIMARY KEY (DNUM, Location),

    CONSTRAINT FK_DepartmentLocations_Department
        FOREIGN KEY (DNUM)
        REFERENCES Department(DNUM)
);
GO

-- ============================================================
-- PART 6: PROJECT
-- DEPARTMENT 1:N PROJECT
--
-- Every Project must be assigned to one Department.
-- ============================================================

CREATE TABLE Project (
    PNumber INT NOT NULL,
    Pname VARCHAR(150) NOT NULL,
    Location VARCHAR(150),
    City VARCHAR(100),
    DNUM INT NOT NULL,

    CONSTRAINT PK_Project
        PRIMARY KEY (PNumber),

    CONSTRAINT FK_Project_Department
        FOREIGN KEY (DNUM)
        REFERENCES Department(DNUM)
);
GO

-- ============================================================
-- PART 7: WORKS_ON
-- EMPLOYEE M:N PROJECT
--
-- WORKS_ON resolves the M:N relationship.
-- Hours is a relationship attribute.
--
-- Composite PK: (SSN, PNumber)
-- ============================================================

CREATE TABLE Works_On (
    SSN VARCHAR(20) NOT NULL,
    PNumber INT NOT NULL,
    Hours DECIMAL(6,2) NOT NULL,

    CONSTRAINT PK_Works_On
        PRIMARY KEY (SSN, PNumber),

    CONSTRAINT FK_WorksOn_Employee
        FOREIGN KEY (SSN)
        REFERENCES Employee(SSN),

    CONSTRAINT FK_WorksOn_Project
        FOREIGN KEY (PNumber)
        REFERENCES Project(PNumber),

    CONSTRAINT CHK_WorksOn_Hours
        CHECK (Hours >= 0)
);
GO

-- ============================================================
-- PART 8: DEPENDENT
-- EMPLOYEE 1:N DEPENDENT
--
-- DEPENDENT is treated as a weak entity.
-- Composite PK: (Employee_SSN, Dependent_Name)
--
-- Case rule:
-- If the employee leaves, dependent information is no longer
-- needed, therefore ON DELETE CASCADE is used.
-- ============================================================

CREATE TABLE Dependent (
    Employee_SSN VARCHAR(20) NOT NULL,
    Dependent_Name VARCHAR(150) NOT NULL,
    Gender VARCHAR(20),
    Birth_Date DATE,

    CONSTRAINT PK_Dependent
        PRIMARY KEY (Employee_SSN, Dependent_Name),

    CONSTRAINT FK_Dependent_Employee
        FOREIGN KEY (Employee_SSN)
        REFERENCES Employee(SSN)
        ON DELETE CASCADE
);
GO

-- ============================================================
-- PART 9: Check All Created Tables
-- ============================================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- ============================================================
-- PART 10: Optional Structure Checks
-- ============================================================

-- EXEC sp_help 'Employee';
-- EXEC sp_help 'Department';
-- EXEC sp_help 'Department_Locations';
-- EXEC sp_help 'Project';
-- EXEC sp_help 'Works_On';
-- EXEC sp_help 'Dependent';

-- ============================================================
-- END OF COMPANY CASE STUDY DDL
-- ============================================================
