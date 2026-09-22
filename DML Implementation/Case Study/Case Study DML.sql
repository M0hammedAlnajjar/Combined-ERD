USE company;

INSERT INTO DEPARTMENT (D_NO, DName, ManagerID, hiredate)
VALUES
('1', 'Headquarters', NULL, '1981-06-19'),
('2', 'Marketing', NULL, '1998-01-01'),
('3', 'Finance', NULL, '2005-03-15'),
('4', 'Administration', NULL, '1995-01-01'),
('5', 'Research', NULL, '1988-05-22');

INSERT INTO EMPLOYEE
(SSN, FName, LName, Gn, BD, DNum, SupervisorID, Salary, Address)
VALUES
('888665555', 'James', 'Borg', 'M', '1937-11-10', '1', NULL, 55000, '450 Stone, Houston TX');

INSERT INTO EMPLOYEE
(SSN, FName, LName, Gn, BD, DNum, SupervisorID, Salary, Address)
VALUES
('333445555', 'Franklin', 'Wong', 'M', '1955-12-08', '5', '888665555', 40000, '638 Voss, Houston TX');

INSERT INTO EMPLOYEE
(SSN, FName, LName, Gn, BD, DNum, SupervisorID, Salary, Address)
VALUES
('987654321', 'Jennifer', 'Wallace', 'F', '1941-06-20', '4', '888665555', 43000, '291 Berry, Bellaire TX');

INSERT INTO EMPLOYEE
(SSN, FName, LName, Gn, BD, DNum, SupervisorID, Salary, Address)
VALUES
('123456789', 'John', 'Smith', 'M', '1965-01-09', '5', '333445555', 30000, '731 Fondren, Houston TX');

INSERT INTO EMPLOYEE
(SSN, FName, LName, Gn, BD, DNum, SupervisorID, Salary, Address)
VALUES
('999887777', 'Alicia', 'Zelaya', 'F', '1968-07-19', '4', '987654321', 25000, '3321 Castle, Spring TX');

UPDATE DEPARTMENT
SET ManagerID = '888665555'
WHERE D_NO = '1';

UPDATE DEPARTMENT
SET ManagerID = '987654321'
WHERE D_NO = '2';

UPDATE DEPARTMENT
SET ManagerID = '999887777'
WHERE D_NO = '3';

UPDATE DEPARTMENT
SET ManagerID = '987654321'
WHERE D_NO = '4';

UPDATE DEPARTMENT
SET ManagerID = '333445555'
WHERE D_NO = '5';

INSERT INTO DEPT_LOCATIONS (DNum, Location)
VALUES
('1', 'Muscat'),
('2', 'Dubai'),
('3', 'Riyadh'),
('4', 'Manama'),
('5', 'Doha');

INSERT INTO PROJECT (PNum, Pname, Location, DNum)
VALUES
('1', 'ProductX', 'Muscat', '5'),
('2', 'ProductY', 'Dubai', '5'),
('3', 'ProductZ', 'Riyadh', '5'),
('10', 'Computerization', 'Manama', '4'),
('20', 'Reorganization', 'Doha', '1');

INSERT INTO WORKS_ON (PNum, EmployeeID, WorkingHours)
VALUES
('1', '123456789', 32.5),
('2', '123456789', 7.5),
('2', '333445555', 10.0),
('3', '333445555', 10.0),
('10', '999887777', 10.0);

INSERT INTO DEPENDENT (SSN, DName, Gn, BD, RELATIONSHIP)
VALUES
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son');

SELECT * FROM DEPARTMENT;
SELECT * FROM DEPT_LOCATIONS;
SELECT * FROM EMPLOYEE;
SELECT * FROM PROJECT;
SELECT * FROM WORKS_ON;
SELECT * FROM DEPENDENT;

UPDATE DEPARTMENT
SET DName = 'Marketing and Sales'
WHERE D_NO = '2';

UPDATE DEPT_LOCATIONS
SET Location = 'Abu Dhabi'
WHERE DNum = '2'
AND Location = 'Dubai';

UPDATE EMPLOYEE
SET Salary = 32000
WHERE SSN = '123456789';

UPDATE PROJECT
SET Location = 'Sohar'
WHERE PNum = '1';

UPDATE WORKS_ON
SET WorkingHours = 35.0
WHERE PNum = '1'
AND EmployeeID = '123456789';

UPDATE DEPENDENT
SET RELATIONSHIP = 'Child'
WHERE SSN = '333445555'
AND DName = 'Alice';

DELETE FROM DEPENDENT
WHERE SSN = '123456789'
AND DName = 'Michael';

DELETE FROM WORKS_ON
WHERE PNum = '10'
AND EmployeeID = '999887777';

DELETE FROM PROJECT
WHERE PNum = '10';

DELETE FROM DEPT_LOCATIONS
WHERE DNum = '3'
AND Location = 'Riyadh';

UPDATE DEPARTMENT
SET ManagerID = NULL
WHERE D_NO = '3';

DELETE FROM EMPLOYEE
WHERE SSN = '999887777';

DELETE FROM DEPARTMENT
WHERE D_NO = '3';

SELECT * FROM DEPARTMENT;
SELECT * FROM DEPT_LOCATIONS;
SELECT * FROM EMPLOYEE;
SELECT * FROM PROJECT;
SELECT * FROM WORKS_ON;
SELECT * FROM DEPENDENT;
