-- ============================================================
-- Hospital Management System
-- Full DDL Script for Microsoft SQL Server / SSMS
-- Source: Level3_Hospital_Mapping_DiagramsNet_Styled(2).drawio
-- ============================================================

-- ============================================================
-- PART 1: Create Database
-- ============================================================

IF DB_ID('hospital_management_db') IS NULL
BEGIN
    CREATE DATABASE hospital_management_db;
END;
GO

USE hospital_management_db;
GO

-- ============================================================
-- PART 2: PATIENT
-- Source attributes:
-- patient_id, name, dob, gender, blood_group, phone, address
--
-- Age is DERIVED from DOB, so Age is NOT stored.
-- ============================================================

CREATE TABLE Patient (
    patient_id INT IDENTITY(1,1),
    [name] VARCHAR(150) NOT NULL,
    dob DATE NOT NULL,
    gender VARCHAR(20),
    blood_group VARCHAR(10),
    phone VARCHAR(30),
    [address] VARCHAR(255),

    CONSTRAINT PK_Patient
        PRIMARY KEY (patient_id)
);
GO

-- ============================================================
-- PART 3: DEPARTMENT
--
-- head_doctor_id is nullable because the mapping states:
-- "Head Doctor is nullable in the base design."
--
-- IMPORTANT:
-- We do NOT add its FK yet because DOCTOR has not been created.
-- We will add that FK later using ALTER TABLE.
-- ============================================================

CREATE TABLE Department (
    department_id INT IDENTITY(1,1),
    [name] VARCHAR(150) NOT NULL,
    head_doctor_id INT NULL,

    CONSTRAINT PK_Department
        PRIMARY KEY (department_id)
);
GO

-- ============================================================
-- PART 4: SERVICE
-- ============================================================

CREATE TABLE Service (
    service_id INT IDENTITY(1,1),
    [name] VARCHAR(150) NOT NULL,
    [type] VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Service
        PRIMARY KEY (service_id),

    CONSTRAINT CHK_Service_Price
        CHECK (price >= 0)
);
GO

-- ============================================================
-- PART 5: DOCTOR
-- DEPARTMENT 1 : N DOCTOR
-- ============================================================

CREATE TABLE Doctor (
    doctor_id INT IDENTITY(1,1),
    [name] VARCHAR(150) NOT NULL,
    specialization VARCHAR(150),
    professional_details VARCHAR(500),
    department_id INT NOT NULL,

    CONSTRAINT PK_Doctor
        PRIMARY KEY (doctor_id),

    CONSTRAINT FK_Doctor_Department
        FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);
GO

-- ============================================================
-- PART 6: Add Head Doctor Foreign Key
--
-- DOCTOR ↔ DEPARTMENT creates a circular dependency:
--   DOCTOR.department_id  → DEPARTMENT
--   DEPARTMENT.head_doctor_id → DOCTOR
--
-- Therefore the second FK is added AFTER both tables exist.
--
-- Base design:
-- - head_doctor_id can be NULL
-- - a Doctor may head multiple Departments
-- ============================================================

ALTER TABLE Department
ADD CONSTRAINT FK_Department_HeadDoctor
    FOREIGN KEY (head_doctor_id)
    REFERENCES Doctor(doctor_id);
GO

-- ============================================================
-- PART 7: DEPARTMENT_SERVICE
--
-- Mapping choice from the supplied file:
-- DEPARTMENT M : N SERVICE
--
-- Composite Primary Key:
-- (department_id, service_id)
-- ============================================================

CREATE TABLE Department_Service (
    department_id INT NOT NULL,
    service_id INT NOT NULL,

    CONSTRAINT PK_Department_Service
        PRIMARY KEY (department_id, service_id),

    CONSTRAINT FK_DepartmentService_Department
        FOREIGN KEY (department_id)
        REFERENCES Department(department_id),

    CONSTRAINT FK_DepartmentService_Service
        FOREIGN KEY (service_id)
        REFERENCES Service(service_id)
);
GO

-- ============================================================
-- PART 8: APPOINTMENT
--
-- PATIENT 1 : N APPOINTMENT
-- DOCTOR  1 : N APPOINTMENT
--
-- Mapping attributes:
-- appointment_id, patient_id, doctor_id,
-- date, time, status, type
-- ============================================================

CREATE TABLE Appointment (
    appointment_id INT IDENTITY(1,1),
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    [date] DATE NOT NULL,
    [time] TIME NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [type] VARCHAR(100),

    CONSTRAINT PK_Appointment
        PRIMARY KEY (appointment_id),

    CONSTRAINT FK_Appointment_Patient
        FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),

    CONSTRAINT FK_Appointment_Doctor
        FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id)
);
GO

-- ============================================================
-- PART 9: APPOINTMENT_SERVICE
--
-- APPOINTMENT M : N SERVICE
--
-- Quantity belongs HERE because it is a Relationship Attribute:
-- quantity varies for each specific Appointment-Service pair.
--
-- Base mapping allows Appointment to exist with 0 services.
-- ============================================================

CREATE TABLE Appointment_Service (
    appointment_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT PK_Appointment_Service
        PRIMARY KEY (appointment_id, service_id),

    CONSTRAINT FK_AppointmentService_Appointment
        FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id),

    CONSTRAINT FK_AppointmentService_Service
        FOREIGN KEY (service_id)
        REFERENCES Service(service_id),

    CONSTRAINT CHK_AppointmentService_Quantity
        CHECK (quantity > 0)
);
GO

-- ============================================================
-- PART 10: MEDICAL_RECORD
--
-- PATIENT 1 : N MEDICAL_RECORD
-- DOCTOR  1 : N MEDICAL_RECORD
-- APPOINTMENT 1 : 0..1 MEDICAL_RECORD
--
-- UNIQUE(appointment_id) enforces:
-- one Appointment can have at most one Medical Record.
-- ============================================================

CREATE TABLE Medical_Record (
    record_id INT IDENTITY(1,1),
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT NOT NULL,
    diagnosis VARCHAR(1000),
    treatment VARCHAR(1000),

    CONSTRAINT PK_Medical_Record
        PRIMARY KEY (record_id),

    CONSTRAINT FK_MedicalRecord_Patient
        FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),

    CONSTRAINT FK_MedicalRecord_Doctor
        FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id),

    CONSTRAINT FK_MedicalRecord_Appointment
        FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id),

    CONSTRAINT UQ_MedicalRecord_Appointment
        UNIQUE (appointment_id)
);
GO

-- ============================================================
-- PART 11: BILL
--
-- PATIENT 1 : N BILL
-- APPOINTMENT 1 : 0..1 BILL
--
-- UNIQUE(appointment_id) enforces:
-- one Appointment can have at most one summarized Bill.
--
-- This follows the BASE model in the supplied file.
-- Partial payments would require a separate PAYMENT entity.
-- ============================================================

CREATE TABLE Bill (
    bill_id INT IDENTITY(1,1),
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_status VARCHAR(50),
    payment_method VARCHAR(50),

    CONSTRAINT PK_Bill
        PRIMARY KEY (bill_id),

    CONSTRAINT FK_Bill_Appointment
        FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id),

    CONSTRAINT FK_Bill_Patient
        FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),

    CONSTRAINT UQ_Bill_Appointment
        UNIQUE (appointment_id),

    CONSTRAINT CHK_Bill_TotalAmount
        CHECK (total_amount >= 0)
);
GO

-- ============================================================
-- PART 12: Check All Created Tables
-- ============================================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- ============================================================
-- PART 13: Optional Structure Checks
-- Uncomment any line when needed.
-- ============================================================

-- EXEC sp_help 'Patient';
-- EXEC sp_help 'Department';
-- EXEC sp_help 'Doctor';
-- EXEC sp_help 'Service';
-- EXEC sp_help 'Department_Service';
-- EXEC sp_help 'Appointment';
-- EXEC sp_help 'Appointment_Service';
-- EXEC sp_help 'Medical_Record';
-- EXEC sp_help 'Bill';

-- ============================================================
-- OPTIONAL IMPROVEMENTS FROM PAGE 3 OF THE SUPPLIED MAPPING
-- These are NOT part of the base schema above.
-- They are shown only as optional extensions.
-- ============================================================

/*

-- ------------------------------------------------------------
-- OPTIONAL A: PAYMENT
-- Needed if partial / multiple payments are required.
-- BILL 1 : N PAYMENT
-- ------------------------------------------------------------

CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1),
    bill_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    method VARCHAR(50),
    [status] VARCHAR(50),

    CONSTRAINT PK_Payment
        PRIMARY KEY (payment_id),

    CONSTRAINT FK_Payment_Bill
        FOREIGN KEY (bill_id)
        REFERENCES Bill(bill_id),

    CONSTRAINT CHK_Payment_Amount
        CHECK (amount > 0)
);
GO

-- ------------------------------------------------------------
-- OPTIONAL B: SERVICE_PRICE_HISTORY
-- Needed if service price changes must be tracked historically.
-- ------------------------------------------------------------

CREATE TABLE Service_Price_History (
    price_history_id INT IDENTITY(1,1),
    service_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    effective_from DATE NOT NULL,
    effective_to DATE NULL,

    CONSTRAINT PK_Service_Price_History
        PRIMARY KEY (price_history_id),

    CONSTRAINT FK_ServicePriceHistory_Service
        FOREIGN KEY (service_id)
        REFERENCES Service(service_id),

    CONSTRAINT CHK_ServicePriceHistory_Price
        CHECK (price >= 0)
);
GO

*/

-- ============================================================
-- END OF HOSPITAL MANAGEMENT SYSTEM DDL
-- ============================================================
