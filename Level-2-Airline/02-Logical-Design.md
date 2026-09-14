# Level 2 - Airline Logical Design

```text
AIRPORT(
  airport_code PK,
  name,
  city,
  state
)

AIRPLANE_TYPE(
  type_name PK,
  company,
  max_seats
)

CAN_LAND(
  airport_code PK/FK -> AIRPORT.airport_code,
  type_name PK/FK -> AIRPLANE_TYPE.type_name
)

AIRPLANE(
  airplane_id PK,
  total_seats,
  type_name FK -> AIRPLANE_TYPE.type_name NOT NULL
)

FLIGHT(
  flight_no PK,
  airline,
  weekdays
)

FLIGHT_LEG(
  leg_no PK,
  flight_no FK -> FLIGHT.flight_no NOT NULL,
  departure_airport_code FK -> AIRPORT.airport_code NOT NULL,
  arrival_airport_code FK -> AIRPORT.airport_code NOT NULL,
  scheduled_dep_time,
  scheduled_arr_time,
  CHECK (departure_airport_code <> arrival_airport_code)
)

LEG_INSTANCE(
  leg_no PK/FK -> FLIGHT_LEG.leg_no,
  flight_date PK,
  airplane_id FK -> AIRPLANE.airplane_id NOT NULL,
  actual_departure_time,
  actual_arrival_time,
  available_seats
)

SEAT(
  airplane_id PK/FK -> AIRPLANE.airplane_id,
  seat_no PK
)

CUSTOMER(
  customer_id PK,
  name,
  phone
)

RESERVATION(
  leg_no PK,
  flight_date PK,
  airplane_id PK,
  seat_no PK,
  customer_id FK -> CUSTOMER.customer_id NOT NULL,
  FK (leg_no, flight_date) -> LEG_INSTANCE(leg_no, flight_date),
  FK (airplane_id, seat_no) -> SEAT(airplane_id, seat_no)
)

FARE(
  flight_no PK/FK -> FLIGHT.flight_no,
  fare_code PK,
  amount,
  restrictions
)
```

## Integrity rules

- `available_seats` must be between zero and the assigned airplane's total seats.
- A Reservation's `airplane_id` must match the airplane assigned to its LegInstance.
- Departure and arrival airports must be different.
- Fare amount must be non-negative.
- `actual_arrival_time` may be null until the leg is completed.

