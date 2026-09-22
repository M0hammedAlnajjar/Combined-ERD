CREATE DATABASE college_management_db;

USE college_management_db;

CREATE TABLE DEPARTMENT (
    Department_id INT IDENTITY(1,1) PRIMARY KEY,
    D_name        VARCHAR(100) NOT NULL
);

CREATE TABLE HOSTEL (
    Hostel_id   INT IDENTITY(1,1) PRIMARY KEY,
    Hostel_name VARCHAR(100) NOT NULL,
    City        VARCHAR(100),
    State       VARCHAR(100),
    Address     VARCHAR(255),
    Pin_code    VARCHAR(20),
    No_of_seats INT NOT NULL,
    CHECK (No_of_seats >= 0)
);

CREATE TABLE FACULTY (
    F_id          INT IDENTITY(1,1) PRIMARY KEY,
    Name          VARCHAR(150) NOT NULL,
    Mobile_no     VARCHAR(30),
    Salary        DECIMAL(10,2),
    Department_id INT NOT NULL,
    FOREIGN KEY (Department_id) REFERENCES DEPARTMENT(Department_id),
    CHECK (Salary IS NULL OR Salary >= 0)
);

CREATE TABLE STUDENT (
    S_id          INT IDENTITY(1,1) PRIMARY KEY,
    F_name        VARCHAR(100) NOT NULL,
    L_name        VARCHAR(100) NOT NULL,
    Name          VARCHAR(200),
    Phone_no      VARCHAR(30),
    DOB           DATE NOT NULL,
    Department_id INT,
    Hostel_id     INT,
    FOREIGN KEY (Department_id) REFERENCES DEPARTMENT(Department_id),
    FOREIGN KEY (Hostel_id) REFERENCES HOSTEL(Hostel_id)
);

CREATE TABLE COURSE (
    Course_id     INT IDENTITY(1,1) PRIMARY KEY,
    Course_name   VARCHAR(150) NOT NULL,
    Duration      VARCHAR(50),
    Department_id INT NOT NULL,
    FOREIGN KEY (Department_id) REFERENCES DEPARTMENT(Department_id)
);

CREATE TABLE SUBJECT (
    Subject_id   INT IDENTITY(1,1) PRIMARY KEY,
    Subject_name VARCHAR(150) NOT NULL,
    F_id         INT NOT NULL,
    FOREIGN KEY (F_id) REFERENCES FACULTY(F_id)
);

CREATE TABLE EXAMS (
    Exam_code     VARCHAR(30) PRIMARY KEY,
    Date          DATE NOT NULL,
    Time          TIME NOT NULL,
    Room          VARCHAR(50),
    Department_id INT NOT NULL,
    FOREIGN KEY (Department_id) REFERENCES DEPARTMENT(Department_id)
);

CREATE TABLE STUDENT_COURSE (
    S_id      INT,
    Course_id INT,
    PRIMARY KEY (S_id, Course_id),
    FOREIGN KEY (S_id) REFERENCES STUDENT(S_id),
    FOREIGN KEY (Course_id) REFERENCES COURSE(Course_id)
);

CREATE TABLE STUDENT_SUBJECT (
    S_id       INT,
    Subject_id INT,
    PRIMARY KEY (S_id, Subject_id),
    FOREIGN KEY (S_id) REFERENCES STUDENT(S_id),
    FOREIGN KEY (Subject_id) REFERENCES SUBJECT(Subject_id)
);

CREATE TABLE STUDENT_EXAM (
    S_id      INT,
    Exam_code VARCHAR(30),
    PRIMARY KEY (S_id, Exam_code),
    FOREIGN KEY (S_id) REFERENCES STUDENT(S_id),
    FOREIGN KEY (Exam_code) REFERENCES EXAMS(Exam_code)
);

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

EXEC sp_help 'Student';

EXEC sp_help 'Student_Course';
