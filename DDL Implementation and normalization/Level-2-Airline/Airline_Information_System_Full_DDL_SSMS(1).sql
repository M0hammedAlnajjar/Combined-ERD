CREATE DATABASE airline_information_db;

USE airline_information_db;

CREATE TABLE AIRPORT (
    airport_code VARCHAR(10) NOT NULL,
    name         VARCHAR(150) NOT NULL,
    city         VARCHAR(100) NOT NULL,
    state        VARCHAR(100),
    PRIMARY KEY (airport_code)
);

CREATE TABLE FLIGHT (
    flight_no    VARCHAR(20) NOT NULL,
    airline      VARCHAR(120) NOT NULL,
    weekdays     VARCHAR(100),
    restrictions VARCHAR(255),
    PRIMARY KEY (flight_no)
);

CREATE TABLE AIRPLANE_TYPE (
    type_name VARCHAR(100) NOT NULL,
    company   VARCHAR(120),
    max_seats INT NOT NULL,
    PRIMARY KEY (type_name),
    CHECK (max_seats > 0)
);

CREATE TABLE CUSTOMER (
    customer_id INT IDENTITY(1,1),
    name        VARCHAR(150) NOT NULL,
    phone       VARCHAR(30) NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE AIRPLANE (
    airplane_id INT IDENTITY(1,1),
    total_seats INT NOT NULL,
    type_name   VARCHAR(100) NOT NULL,
    PRIMARY KEY (airplane_id),
    FOREIGN KEY (type_name) REFERENCES AIRPLANE_TYPE(type_name),
    CHECK (total_seats > 0)
);

CREATE TABLE AIRPORT_AIRPLANE_TYPE (
    airport_code VARCHAR(10) NOT NULL,
    type_name    VARCHAR(100) NOT NULL,
    PRIMARY KEY (airport_code, type_name),
    FOREIGN KEY (airport_code) REFERENCES AIRPORT(airport_code),
    FOREIGN KEY (type_name) REFERENCES AIRPLANE_TYPE(type_name)
);

CREATE TABLE FLIGHT_LEG (
    leg_no             INT NOT NULL,
    flight_no          VARCHAR(20) NOT NULL,
    scheduled_dep_time TIME NOT NULL,
    scheduled_arr_time TIME NOT NULL,
    dep_airport_code   VARCHAR(10) NOT NULL,
    arr_airport_code   VARCHAR(10) NOT NULL,
    PRIMARY KEY (leg_no),
    FOREIGN KEY (flight_no) REFERENCES FLIGHT(flight_no),
    FOREIGN KEY (dep_airport_code) REFERENCES AIRPORT(airport_code),
    FOREIGN KEY (arr_airport_code) REFERENCES AIRPORT(airport_code),
    CHECK (dep_airport_code <> arr_airport_code)
);

CREATE TABLE LEG_INSTANCE (
    leg_no          INT NOT NULL,
    instance_date   DATE NOT NULL,
    arrival_time    TIME,
    departure_time  TIME,
    available_seats INT NOT NULL,
    airplane_id     INT NOT NULL,
    PRIMARY KEY (leg_no, instance_date),
    FOREIGN KEY (leg_no) REFERENCES FLIGHT_LEG(leg_no),
    FOREIGN KEY (airplane_id) REFERENCES AIRPLANE(airplane_id),
    CHECK (available_seats >= 0),
    UNIQUE (leg_no, instance_date, airplane_id)
);

CREATE TABLE FARE (
    flight_no VARCHAR(20) NOT NULL,
    fare_code VARCHAR(30) NOT NULL,
    amount    DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (flight_no, fare_code),
    FOREIGN KEY (flight_no) REFERENCES FLIGHT(flight_no),
    CHECK (amount >= 0)
);

CREATE TABLE SEAT (
    airplane_id INT NOT NULL,
    seat_no     VARCHAR(10) NOT NULL,
    PRIMARY KEY (airplane_id, seat_no),
    FOREIGN KEY (airplane_id) REFERENCES AIRPLANE(airplane_id)
);

CREATE TABLE RESERVATION (
    customer_id   INT NOT NULL,
    leg_no        INT NOT NULL,
    instance_date DATE NOT NULL,
    airplane_id   INT NOT NULL,
    seat_no       VARCHAR(10) NOT NULL,
    PRIMARY KEY (
        customer_id,
        leg_no,
        instance_date,
        airplane_id,
        seat_no
    ),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (leg_no, instance_date, airplane_id)
        REFERENCES LEG_INSTANCE(leg_no, instance_date, airplane_id),
    FOREIGN KEY (airplane_id, seat_no)
        REFERENCES SEAT(airplane_id, seat_no),
    UNIQUE (leg_no, instance_date, airplane_id, seat_no)
);

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

EXEC sp_help 'Flight_Leg';

EXEC sp_help 'Leg_Instance';

EXEC sp_help 'Reservation';
