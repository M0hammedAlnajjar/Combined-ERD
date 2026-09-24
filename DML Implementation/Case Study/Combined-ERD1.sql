USE company_case_study_db;

INSERT INTO DEPARTMENT (DNUM, DName, Manager_SSN,Manager_Hire_Date)
VALUES
('1', 'Headquarters', NULL, '1981-06-19'),
('2', 'Marketing', NULL, '1998-01-01'),
('3', 'Finance', NULL, '2005-03-15'),
('4', 'Administration', NULL, '1995-01-01'),
('5', 'Research', NULL, '1988-05-22');


INSERT INTO EMPLOYEE
(SSN, FName, LName, Gender, Birth_Date, DNum, Supervisor_SSN, Salary, Address)
VALUES
('888665555', 'James', 'Borg', 'M', '1937-11-10',
 '1', NULL, 55000, '450 Stone, Houston TX');

 INSERT INTO EMPLOYEE
(SSN, FName, LName, Gender, Birth_Date, DNum, Supervisor_SSN, Salary, Address)
VALUES
('333445555', 'Franklin', 'Wong', 'M', '1955-12-08',
 '5', '888665555', 40000, '638 Voss, Houston TX');

 INSERT INTO EMPLOYEE
(SSN, FName, LName, Gender, Birth_Date, DNum, Supervisor_SSN, Salary, Address)
VALUES
('987654321', 'Jennifer', 'Wallace', 'F', '1941-06-20',
 '4', '888665555', 43000, '291 Berry, Bellaire TX');


 INSERT INTO EMPLOYEE
(SSN, FName, LName, Gender, Birth_Date, DNum, Supervisor_SSN, Salary, Address)
VALUES
('123456789', 'John', 'Smith', 'M', '1965-01-09',
 '5', '333445555', 30000, '731 Fondren, Houston TX');

 INSERT INTO EMPLOYEE
(SSN, FName, LName, Gender, Birth_Date, DNum, Supervisor_SSN, Salary, Address)
VALUES
('999887777', 'Alicia', 'Zelaya', 'F', '1968-07-19',
 '4', '987654321', 25000, '3321 Castle, Spring TX');


 UPDATE DEPARTMENT
SET Manager_SSN = '888665555'
WHERE DNUM = '1';

UPDATE DEPARTMENT
SET Manager_SSN  = '987654321'
WHERE DNUM = '2';

UPDATE DEPARTMENT
SET Manager_SSN  = '999887777'
WHERE DNUM = '3';

UPDATE DEPARTMENT
SET Manager_SSN  = '987654321'
WHERE DNUM = '4';

UPDATE DEPARTMENT
SET Manager_SSN  = '333445555'
WHERE DNUM = '5';

INSERT INTO Department_Locations(DNum, Location)
VALUES
('1', 'Muscat'),
('2', 'Dubai'),
('3', 'Riyadh'),
('4', 'Manama'),
('5', 'Doha');



INSERT INTO PROJECT (PNumber, Pname, Location, DNum)
VALUES
('1', 'ProductX', 'Muscat', '5'),
('2', 'ProductY', 'Dubai', '5'),
('3', 'ProductZ', 'Riyadh', '5'),
('10', 'Computerization', 'Manama', '4'),
('20', 'Reorganization', 'Doha', '1');

INSERT INTO WORKS_ON (PNumber,SSN,Hours)
VALUES
('1', '123456789', 32.5),
('2', '123456789', 7.5),
('2', '333445555', 10.0),
('3', '333445555', 10.0),
('10', '999887777', 10.0);


INSERT INTO DEPENDENT (Employee_SSN, Dependent_Name, Gender, Birth_Date, RELATIONSHIP)
VALUES
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son');


UPDATE EMPLOYEE
SET Salary = Salary * 1.10
WHERE DNum = '5';


UPDATE PROJECT
SET Location = 'Muscat'
WHERE PNumber = '2'
AND Location = 'Dubai';


UPDATE EMPLOYEE
SET Salary = 35000
WHERE SSN = '123456789';

UPDATE DEPARTMENT
SET DName = 'Financial Management'
WHERE DNUM = '3'
AND DName = 'Finance';


DELETE FROM DEPENDENT
WHERE Employee_SSN = '123456789'
AND Dependent_Name = 'Michael';
	
DELETE FROM WORKS_ON
WHERE SSN = '999887777'
AND PNumber = '10';

DELETE FROM PROJECT
WHERE PNumber = '20';


DELETE FROM EMPLOYEE
WHERE SSN = '123456789';


SELECT
    E.FName,
    E.LName,
    D.DName
FROM EMPLOYEE AS E
INNER JOIN DEPARTMENT AS D
    ON E.DNum = D.DName;

SELECT
    E.FName,
    E.LName,
    D.DName
FROM EMPLOYEE AS E
INNER JOIN DEPARTMENT AS D
    ON E.DNum = D.DNUM;


SELECT
    E.FName,
    E.LName,
    P.Pname,
    W.Hours
FROM EMPLOYEE AS E
INNER JOIN WORKS_ON AS W
    ON E.SSN = W.SSN
INNER JOIN PROJECT AS P
    ON W.PNumber = P.PNumber;


SELECT
    D.DNUM,
    D.DName,
    DL.Location
FROM DEPARTMENT AS D
INNER JOIN Department_Locations AS DL
    ON D.DNUM = DL.DNum;


SELECT
    E.FName,
    E.LName,
    DP.Dependent_Name,
    DP.RELATIONSHIP
FROM EMPLOYEE AS E
INNER JOIN DEPENDENT AS DP
    ON E.SSN = DP.Employee_SSN;


SELECT
    E.SSN,
    E.FName,
    E.LName,
    DP.Dependent_Name,
    DP.RELATIONSHIP
FROM EMPLOYEE AS E
LEFT JOIN DEPENDENT AS DP
    ON E.SSN = DP.Employee_SSN;


SELECT
    E.FName,
    E.LName,
    D.DName,
    P.Pname,
    P.Location,
    W.Hours
FROM EMPLOYEE AS E
INNER JOIN DEPARTMENT AS D
    ON E.DNum = D.DNUM
INNER JOIN WORKS_ON AS W
    ON E.SSN = W.SSN
INNER JOIN PROJECT AS P
    ON W.PNumber = P.PNumber;


SELECT COUNT(*) AS TotalEmployees
FROM EMPLOYEE;


SELECT
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary,
    MIN(Salary) AS MinimumSalary,
    MAX(Salary) AS MaximumSalary
FROM EMPLOYEE;


SELECT
    DNum,
    COUNT(*) AS NumberOfEmployees
FROM EMPLOYEE
GROUP BY DNum;


SELECT
    DNum,
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary
FROM EMPLOYEE
GROUP BY DNum;


SELECT
    PNumber,
    SUM(Hours) AS TotalHours
FROM WORKS_ON
GROUP BY PNumber;


SELECT
    SSN,
    SUM(Hours) AS TotalHours
FROM WORKS_ON
GROUP BY SSN;


SELECT
    D.DName,
    COUNT(E.SSN) AS NumberOfEmployees,
    SUM(E.Salary) AS TotalSalary,
    AVG(E.Salary) AS AverageSalary
FROM DEPARTMENT AS D
INNER JOIN EMPLOYEE AS E
    ON D.DNUM = E.DNum
GROUP BY D.DNUM, D.DName;


SELECT
    P.Pname,
    COUNT(DISTINCT W.SSN) AS NumberOfEmployees,
    SUM(W.Hours) AS TotalHours,
    AVG(W.Hours) AS AverageHours
FROM PROJECT AS P
INNER JOIN WORKS_ON AS W
    ON P.PNumber = W.PNumber
GROUP BY P.PNumber, P.Pname;


SELECT
    D.DName,
    COUNT(DISTINCT P.PNumber) AS NumberOfProjects,
    SUM(W.Hours) AS TotalWorkingHours
FROM DEPARTMENT AS D
INNER JOIN PROJECT AS P
    ON D.DNUM = P.DNum
LEFT JOIN WORKS_ON AS W
    ON P.PNumber = W.PNumber
GROUP BY D.DNUM, D.DName;


SELECT
    D.DNUM,
    D.DName,
    AVG(E.Salary) AS AverageSalary
FROM DEPARTMENT AS D
INNER JOIN EMPLOYEE AS E
    ON D.DNUM = E.DNum
GROUP BY D.DNUM, D.DName
HAVING AVG(E.Salary) > 30000;


SELECT
    P.PNumber,
    P.Pname,
    SUM(W.Hours) AS TotalHours
FROM PROJECT AS P
INNER JOIN WORKS_ON AS W
    ON P.PNumber = W.PNumber
GROUP BY P.PNumber, P.Pname
HAVING SUM(W.Hours) > 15;


SELECT
    D.DNUM,
    D.DName,
    COUNT(E.SSN) AS NumberOfEmployees
FROM DEPARTMENT AS D
INNER JOIN EMPLOYEE AS E
    ON D.DNUM = E.DNum
GROUP BY D.DNUM, D.DName
HAVING COUNT(E.SSN) > 1;


SELECT * FROM DEPENDENT;
SELECT * FROM WORKS_ON;
SELECT * FROM PROJECT;
SELECT * FROM Department_Locations;
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
Select * from DEPENDENT
Select * from WORKS_ON
Select * from PROJECT 
Select *from Department_Locations
Select * from EMPLOYEE
Select * from DEPARTMENT
