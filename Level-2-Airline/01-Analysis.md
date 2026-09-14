# Level 2 - Airline Information System Analysis

## Entities and identifiers

| Entity | Identifier | Other attributes | Strength |
|---|---|---|---|
| Airport | airport_code | Name, City, State | Strong |
| AirplaneType | type_name | Company, max_seats | Strong |
| Airplane | airplane_id | total_seats | Strong |
| Flight | flight_no | Airline, Weekdays | Strong; flight_no is an introduced identifier |
| FlightLeg | leg_no | scheduled_dep_time, scheduled_arr_time | Strong because the brief states leg_no is unique |
| LegInstance | leg_no + flight_date | actual_departure_time, actual_arrival_time, available_seats | Weak; identified by FlightLeg and partial key flight_date |
| Fare | flight_no + fare_code | Amount, Restrictions | Weak under Flight; fare_code is a partial key |
| Seat | airplane_id + seat_no | - | Weak under Airplane; seat_no is a partial key |
| Customer | customer_id | Name, Phone | Strong; customer_id is introduced because a name or phone is not a safe primary key |
| Reservation | leg_no + flight_date + airplane_id + seat_no | customer_id | Associative/existence-dependent result of the ternary reservation relationship |

## Relationships

| Relationship | Cardinality | Rule |
|---|---|---|
| Flight contains FlightLeg | 1:N | Every leg belongs to exactly one Flight. |
| FlightLeg departs from Airport | N:1 | Each leg has one departure Airport; an Airport is used by many legs. |
| FlightLeg arrives at Airport | N:1 | Each leg has one arrival Airport; an Airport is used by many legs. |
| FlightLeg has LegInstance | 1:N | A LegInstance cannot exist without its FlightLeg. |
| AirplaneType classifies Airplane | 1:N | Every Airplane has exactly one type. |
| Airport allows AirplaneType | M:N | Captured by CAN_LAND. |
| Airplane operates LegInstance | 1:N over time | Every LegInstance uses exactly one Airplane. |
| Airplane contains Seat | 1:N | Seat is identified by Airplane plus seat number. |
| Flight offers Fare | 1:N | A Fare is identified within one Flight. |
| Customer reserves Seat for LegInstance | Ternary | Customer, Seat, and LegInstance must be known together. |

## Key decisions

1. `Customer` is a separate strong entity with a surrogate `customer_id`. Phone is a candidate key only if the company guarantees one unique phone per customer.
2. The conceptual ERD uses a ternary `RESERVES` relationship connecting Customer, Seat, and LegInstance. In the relational model it becomes `RESERVATION`.
3. A seat may be reserved only once for one LegInstance. The Reservation composite primary key enforces that rule.
4. The reserved Seat must belong to the same Airplane assigned to the LegInstance. This cross-table rule requires a composite foreign key, assertion, trigger, or transaction-level validation.
5. Scheduled times belong to FlightLeg; actual times belong to LegInstance.

