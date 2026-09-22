CREATE DATABASE hospital_management_db;

USE hospital_management_db;

CREATE TABLE PATIENT (
    patient_id  INT IDENTITY(1,1) PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    dob         DATE NOT NULL,
    gender      VARCHAR(20),
    blood_group VARCHAR(10),
    phone       VARCHAR(30),
    address     VARCHAR(255)
);

CREATE TABLE DEPARTMENT (
    department_id  INT IDENTITY(1,1) PRIMARY KEY,
    name           VARCHAR(150) NOT NULL,
    head_doctor_id INT
);

CREATE TABLE SERVICE (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    name       VARCHAR(150) NOT NULL,
    type       VARCHAR(100),
    price      DECIMAL(10,2) NOT NULL,
    CHECK (price >= 0)
);

CREATE TABLE DOCTOR (
    doctor_id            INT IDENTITY(1,1) PRIMARY KEY,
    name                 VARCHAR(150) NOT NULL,
    specialization       VARCHAR(150),
    professional_details VARCHAR(500),
    department_id        INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id)
);

ALTER TABLE DEPARTMENT
ADD CONSTRAINT fk_department_head_doctor
FOREIGN KEY (head_doctor_id) REFERENCES DOCTOR(doctor_id);

CREATE TABLE DEPARTMENT_SERVICE (
    department_id INT NOT NULL,
    service_id    INT NOT NULL,
    PRIMARY KEY (department_id, service_id),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id),
    FOREIGN KEY (service_id) REFERENCES SERVICE(service_id)
);

CREATE TABLE APPOINTMENT (
    appointment_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id     INT NOT NULL,
    doctor_id      INT NOT NULL,
    date           DATE NOT NULL,
    time           TIME NOT NULL,
    status         VARCHAR(50) NOT NULL,
    type           VARCHAR(100),
    FOREIGN KEY (patient_id) REFERENCES PATIENT(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES DOCTOR(doctor_id)
);

CREATE TABLE APPOINTMENT_SERVICE (
    appointment_id INT NOT NULL,
    service_id     INT NOT NULL,
    quantity       INT NOT NULL,
    PRIMARY KEY (appointment_id, service_id),
    FOREIGN KEY (appointment_id) REFERENCES APPOINTMENT(appointment_id),
    FOREIGN KEY (service_id) REFERENCES SERVICE(service_id),
    CHECK (quantity > 0)
);

CREATE TABLE MEDICAL_RECORD (
    record_id      INT IDENTITY(1,1) PRIMARY KEY,
    patient_id     INT NOT NULL,
    doctor_id      INT NOT NULL,
    appointment_id INT NOT NULL,
    diagnosis      VARCHAR(1000),
    treatment      VARCHAR(1000),
    FOREIGN KEY (patient_id) REFERENCES PATIENT(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES DOCTOR(doctor_id),
    FOREIGN KEY (appointment_id) REFERENCES APPOINTMENT(appointment_id),
    UNIQUE (appointment_id)
);

CREATE TABLE BILL (
    bill_id        INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id INT NOT NULL,
    patient_id     INT NOT NULL,
    total_amount   DECIMAL(12,2) NOT NULL,
    payment_status VARCHAR(50),
    payment_method VARCHAR(50),
    FOREIGN KEY (appointment_id) REFERENCES APPOINTMENT(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES PATIENT(patient_id),
    UNIQUE (appointment_id),
    CHECK (total_amount >= 0)
);

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

CREATE TABLE PAYMENT (
    payment_id   INT IDENTITY(1,1) PRIMARY KEY,
    bill_id      INT NOT NULL,
    amount       DECIMAL(12,2) NOT NULL,
    payment_date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    method       VARCHAR(50),
    status       VARCHAR(50),
    FOREIGN KEY (bill_id) REFERENCES BILL(bill_id),
    CHECK (amount > 0)
);

CREATE TABLE SERVICE_PRICE_HISTORY (
    price_history_id INT IDENTITY(1,1) PRIMARY KEY,
    service_id       INT NOT NULL,
    price            DECIMAL(10,2) NOT NULL,
    effective_from   DATE NOT NULL,
    effective_to     DATE,
    FOREIGN KEY (service_id) REFERENCES SERVICE(service_id),
    CHECK (price >= 0)
);
