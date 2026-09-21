-- ============================================================
-- Airline Information System
-- Full DDL Script for Microsoft SQL Server / SSMS
-- ============================================================

-- PART 1: Create Database
IF DB_ID('airline_information_db') IS NULL
BEGIN
    CREATE DATABASE airline_information_db;
END;
GO

USE airline_information_db;
GO

-- ============================================================
-- PART 2: AIRPORT
-- ============================================================

CREATE TABLE Airport (
    airport_code VARCHAR(10) NOT NULL,
    name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),

    CONSTRAINT PK_Airport
        PRIMARY KEY (airport_code)
);
GO

-- ============================================================
-- PART 3: FLIGHT
-- NOTE:
-- The case describes Flight but does not explicitly provide
-- a primary-key attribute. flight_no is used as the identifier.
-- ============================================================

CREATE TABLE Flight (
    flight_no VARCHAR(20) NOT NULL,
    airline VARCHAR(120) NOT NULL,
    weekdays VARCHAR(100),
    restrictions VARCHAR(255),

    CONSTRAINT PK_Flight
        PRIMARY KEY (flight_no)
);
GO

-- ============================================================
-- PART 4: AIRPLANE_TYPE
-- ============================================================

CREATE TABLE Airplane_Type (
    type_name VARCHAR(100) NOT NULL,
    company VARCHAR(120),
    max_seats INT NOT NULL,

    CONSTRAINT PK_Airplane_Type
        PRIMARY KEY (type_name),

    CONSTRAINT CHK_AirplaneType_MaxSeats
        CHECK (max_seats > 0)
);
GO

-- ============================================================
-- PART 5: CUSTOMER
-- NOTE:
-- The case gives customer name and phone but no customer_id.
-- customer_id is introduced as a surrogate key.
-- ============================================================

CREATE TABLE Customer (
    customer_id INT IDENTITY(1,1),
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NOT NULL,

    CONSTRAINT PK_Customer
        PRIMARY KEY (customer_id)
);
GO

-- ============================================================
-- PART 6: AIRPLANE
-- AIRPLANE_TYPE 1 : N AIRPLANE
-- ============================================================

CREATE TABLE Airplane (
    airplane_id INT IDENTITY(1,1),
    total_seats INT NOT NULL,
    type_name VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Airplane
        PRIMARY KEY (airplane_id),

    CONSTRAINT FK_Airplane_Type
        FOREIGN KEY (type_name)
        REFERENCES Airplane_Type(type_name),

    CONSTRAINT CHK_Airplane_TotalSeats
        CHECK (total_seats > 0)
);
GO

-- ============================================================
-- PART 7: AIRPORT_AIRPLANE_TYPE
-- Resolves AIRPORT M : N AIRPLANE_TYPE
-- ============================================================

CREATE TABLE Airport_Airplane_Type (
    airport_code VARCHAR(10) NOT NULL,
    type_name VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Airport_Airplane_Type
        PRIMARY KEY (airport_code, type_name),

    CONSTRAINT FK_AAT_Airport
        FOREIGN KEY (airport_code)
        REFERENCES Airport(airport_code),

    CONSTRAINT FK_AAT_AirplaneType
        FOREIGN KEY (type_name)
        REFERENCES Airplane_Type(type_name)
);
GO

-- ============================================================
-- PART 8: FLIGHT_LEG
-- FLIGHT 1 : N FLIGHT_LEG
-- AIRPORT 1 : N FLIGHT_LEG (departure role)
-- AIRPORT 1 : N FLIGHT_LEG (arrival role)
-- ============================================================

CREATE TABLE Flight_Leg (
    leg_no INT NOT NULL,
    flight_no VARCHAR(20) NOT NULL,
    scheduled_dep_time TIME NOT NULL,
    scheduled_arr_time TIME NOT NULL,
    dep_airport_code VARCHAR(10) NOT NULL,
    arr_airport_code VARCHAR(10) NOT NULL,

    CONSTRAINT PK_Flight_Leg
        PRIMARY KEY (leg_no),

    CONSTRAINT FK_FlightLeg_Flight
        FOREIGN KEY (flight_no)
        REFERENCES Flight(flight_no),

    CONSTRAINT FK_FlightLeg_DepAirport
        FOREIGN KEY (dep_airport_code)
        REFERENCES Airport(airport_code),

    CONSTRAINT FK_FlightLeg_ArrAirport
        FOREIGN KEY (arr_airport_code)
        REFERENCES Airport(airport_code),

    CONSTRAINT CHK_FlightLeg_DifferentAirports
        CHECK (dep_airport_code <> arr_airport_code)
);
GO

-- ============================================================
-- PART 9: LEG_INSTANCE
-- Weak / identifying dependency on FLIGHT_LEG
-- A specific leg occurrence is identified by:
-- (leg_no, instance_date)
-- ============================================================

CREATE TABLE Leg_Instance (
    leg_no INT NOT NULL,
    instance_date DATE NOT NULL,
    arrival_time TIME,
    departure_time TIME,
    available_seats INT NOT NULL,
    airplane_id INT NOT NULL,

    CONSTRAINT PK_Leg_Instance
        PRIMARY KEY (leg_no, instance_date),

    CONSTRAINT FK_LegInstance_FlightLeg
        FOREIGN KEY (leg_no)
        REFERENCES Flight_Leg(leg_no),

    CONSTRAINT FK_LegInstance_Airplane
        FOREIGN KEY (airplane_id)
        REFERENCES Airplane(airplane_id),

    CONSTRAINT CHK_LegInstance_AvailableSeats
        CHECK (available_seats >= 0),

    CONSTRAINT UQ_LegInstance_Airplane
        UNIQUE (leg_no, instance_date, airplane_id)
);
GO

-- ============================================================
-- PART 10: FARE
-- FLIGHT 1 : N FARE
-- Composite key: (flight_no, fare_code)
-- ============================================================

CREATE TABLE Fare (
    flight_no VARCHAR(20) NOT NULL,
    fare_code VARCHAR(30) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Fare
        PRIMARY KEY (flight_no, fare_code),

    CONSTRAINT FK_Fare_Flight
        FOREIGN KEY (flight_no)
        REFERENCES Flight(flight_no),

    CONSTRAINT CHK_Fare_Amount
        CHECK (amount >= 0)
);
GO

-- ============================================================
-- PART 11: SEAT
-- Seat number is unique inside an airplane.
-- Composite key: (airplane_id, seat_no)
-- ============================================================

CREATE TABLE Seat (
    airplane_id INT NOT NULL,
    seat_no VARCHAR(10) NOT NULL,

    CONSTRAINT PK_Seat
        PRIMARY KEY (airplane_id, seat_no),

    CONSTRAINT FK_Seat_Airplane
        FOREIGN KEY (airplane_id)
        REFERENCES Airplane(airplane_id)
);
GO

-- ============================================================
-- PART 12: RESERVATION
-- Represents the required 3-way relationship:
-- CUSTOMER + SEAT + LEG_INSTANCE
-- ============================================================

CREATE TABLE Reservation (
    customer_id INT NOT NULL,
    leg_no INT NOT NULL,
    instance_date DATE NOT NULL,
    airplane_id INT NOT NULL,
    seat_no VARCHAR(10) NOT NULL,

    CONSTRAINT PK_Reservation
        PRIMARY KEY (
            customer_id,
            leg_no,
            instance_date,
            airplane_id,
            seat_no
        ),

    CONSTRAINT FK_Reservation_Customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    CONSTRAINT FK_Reservation_LegInstance
        FOREIGN KEY (leg_no, instance_date, airplane_id)
        REFERENCES Leg_Instance(leg_no, instance_date, airplane_id),

    CONSTRAINT FK_Reservation_Seat
        FOREIGN KEY (airplane_id, seat_no)
        REFERENCES Seat(airplane_id, seat_no),

    CONSTRAINT UQ_Reservation_SeatPerInstance
        UNIQUE (leg_no, instance_date, airplane_id, seat_no)
);
GO

-- ============================================================
-- PART 13: Check all created tables
-- ============================================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- Optional structure checks:
-- EXEC sp_help 'Flight_Leg';
-- EXEC sp_help 'Leg_Instance';
-- EXEC sp_help 'Reservation';
