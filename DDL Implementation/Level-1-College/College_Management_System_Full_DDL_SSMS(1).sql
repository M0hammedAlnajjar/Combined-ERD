-- ============================================================
-- College Management System
-- Full DDL Script for Microsoft SQL Server / SSMS
-- ============================================================

-- PART 1: Create Database
IF DB_ID('college_management_db') IS NULL
BEGIN
    CREATE DATABASE college_management_db;
END;
GO

USE college_management_db;
GO

-- ============================================================
-- PART 2: DEPARTMENT
-- ============================================================

CREATE TABLE Department (
    Department_id INT IDENTITY(1,1),
    D_name VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Department
        PRIMARY KEY (Department_id)
);
GO

-- ============================================================
-- PART 3: HOSTEL
-- ============================================================

CREATE TABLE Hostel (
    Hostel_id INT IDENTITY(1,1),
    Hostel_name VARCHAR(100) NOT NULL,
    City VARCHAR(100),
    State VARCHAR(100),
    Address VARCHAR(255),
    Pin_code VARCHAR(20),
    No_of_seats INT NOT NULL,

    CONSTRAINT PK_Hostel
        PRIMARY KEY (Hostel_id),

    CONSTRAINT CHK_Hostel_Seats
        CHECK (No_of_seats >= 0)
);
GO

-- ============================================================
-- PART 4: FACULTY
-- DEPARTMENT 1 : N FACULTY
-- ============================================================

CREATE TABLE Faculty (
    F_id INT IDENTITY(1,1),
    Name VARCHAR(150) NOT NULL,
    Mobile_no VARCHAR(30),
    Salary DECIMAL(10,2),
    Department_id INT NOT NULL,

    CONSTRAINT PK_Faculty
        PRIMARY KEY (F_id),

    CONSTRAINT FK_Faculty_Department
        FOREIGN KEY (Department_id)
        REFERENCES Department(Department_id),

    CONSTRAINT CHK_Faculty_Salary
        CHECK (Salary IS NULL OR Salary >= 0)
);
GO

-- ============================================================
-- PART 5: STUDENT
-- DEPARTMENT 1 : N STUDENT
-- HOSTEL 1 : N STUDENT
-- Age is derived from DOB and is not stored.
-- ============================================================

CREATE TABLE Student (
    S_id INT IDENTITY(1,1),
    F_name VARCHAR(100) NOT NULL,
    L_name VARCHAR(100) NOT NULL,
    Name VARCHAR(200),
    Phone_no VARCHAR(30),
    DOB DATE NOT NULL,
    Department_id INT NULL,
    Hostel_id INT NULL,

    CONSTRAINT PK_Student
        PRIMARY KEY (S_id),

    CONSTRAINT FK_Student_Department
        FOREIGN KEY (Department_id)
        REFERENCES Department(Department_id),

    CONSTRAINT FK_Student_Hostel
        FOREIGN KEY (Hostel_id)
        REFERENCES Hostel(Hostel_id)
);
GO

-- ============================================================
-- PART 6: COURSE
-- DEPARTMENT 1 : N COURSE
-- ============================================================

CREATE TABLE Course (
    Course_id INT IDENTITY(1,1),
    Course_name VARCHAR(150) NOT NULL,
    Duration VARCHAR(50),
    Department_id INT NOT NULL,

    CONSTRAINT PK_Course
        PRIMARY KEY (Course_id),

    CONSTRAINT FK_Course_Department
        FOREIGN KEY (Department_id)
        REFERENCES Department(Department_id)
);
GO

-- ============================================================
-- PART 7: SUBJECT
-- FACULTY 1 : N SUBJECT
-- ============================================================

CREATE TABLE Subject (
    Subject_id INT IDENTITY(1,1),
    Subject_name VARCHAR(150) NOT NULL,
    F_id INT NOT NULL,

    CONSTRAINT PK_Subject
        PRIMARY KEY (Subject_id),

    CONSTRAINT FK_Subject_Faculty
        FOREIGN KEY (F_id)
        REFERENCES Faculty(F_id)
);
GO

-- ============================================================
-- PART 8: EXAMS
-- DEPARTMENT 1 : N EXAMS
-- ============================================================

CREATE TABLE Exams (
    Exam_code VARCHAR(30),
    [Date] DATE NOT NULL,
    [Time] TIME NOT NULL,
    Room VARCHAR(50),
    Department_id INT NOT NULL,

    CONSTRAINT PK_Exams
        PRIMARY KEY (Exam_code),

    CONSTRAINT FK_Exams_Department
        FOREIGN KEY (Department_id)
        REFERENCES Department(Department_id)
);
GO

-- ============================================================
-- PART 9: STUDENT_COURSE
-- STUDENT M : N COURSE
-- ============================================================

CREATE TABLE Student_Course (
    S_id INT,
    Course_id INT,

    CONSTRAINT PK_Student_Course
        PRIMARY KEY (S_id, Course_id),

    CONSTRAINT FK_StudentCourse_Student
        FOREIGN KEY (S_id)
        REFERENCES Student(S_id),

    CONSTRAINT FK_StudentCourse_Course
        FOREIGN KEY (Course_id)
        REFERENCES Course(Course_id)
);
GO

-- ============================================================
-- PART 10: STUDENT_SUBJECT
-- STUDENT M : N SUBJECT
-- ============================================================

CREATE TABLE Student_Subject (
    S_id INT,
    Subject_id INT,

    CONSTRAINT PK_Student_Subject
        PRIMARY KEY (S_id, Subject_id),

    CONSTRAINT FK_StudentSubject_Student
        FOREIGN KEY (S_id)
        REFERENCES Student(S_id),

    CONSTRAINT FK_StudentSubject_Subject
        FOREIGN KEY (Subject_id)
        REFERENCES Subject(Subject_id)
);
GO

-- ============================================================
-- PART 11: STUDENT_EXAM
-- STUDENT M : N EXAMS
-- ============================================================

CREATE TABLE Student_Exam (
    S_id INT,
    Exam_code VARCHAR(30),

    CONSTRAINT PK_Student_Exam
        PRIMARY KEY (S_id, Exam_code),

    CONSTRAINT FK_StudentExam_Student
        FOREIGN KEY (S_id)
        REFERENCES Student(S_id),

    CONSTRAINT FK_StudentExam_Exam
        FOREIGN KEY (Exam_code)
        REFERENCES Exams(Exam_code)
);
GO

-- ============================================================
-- PART 12: Check Created Tables
-- ============================================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- Optional detailed checks:
-- EXEC sp_help 'Student';
-- EXEC sp_help 'Student_Course';
