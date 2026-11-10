# Flight Booking System — database design

My case study records traveller, flight, booking, payment.

## Users

- travellers
- booking staff
- operations analysts

## Main operations

- search scheduled flights
- create or cancel a booking
- assign a seat
- record a payment
- review bookings and revenue

## Entities

| Entity | Information stored |
| --- | --- |
| traveller | Stores traveller details used by bookings. |
| flight | Stores a scheduled flight and its route and operational status. |
| booking | Associates one traveller with one scheduled flight and records their seat and booking lifecycle. |
| payment | Stores the payment amount, currency, and status for a booking. |

## traveller

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| traveller_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| loyalty_tier | TEXT |  | Yes |
- Unique key: (email).

## flight

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| flight_id | BIGINT | PK | Yes |
| flight_number | TEXT |  | Yes |
| departure_airport | TEXT |  | Yes |
| arrival_airport | TEXT |  | Yes |
| departure_ts | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- Unique key: (flight_number, departure_ts).

## booking

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| booking_id | BIGINT | PK | Yes |
| traveller_id | BIGINT | FK | Yes |
| flight_id | BIGINT | FK | Yes |
| seat_code | TEXT |  | Yes |
| booking_status | TEXT |  | Yes |
| booked_ts | TIMESTAMPTZ |  | Yes |
- traveller_id → traveller.traveller_id
- flight_id → flight.flight_id

## payment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| booking_id | BIGINT | FK, Unique | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| currency | TEXT |  | Yes |
| payment_status | TEXT |  | Yes |
| paid_ts | TIMESTAMPTZ |  | Yes |
- booking_id → booking.booking_id
- Unique key: (booking_id).

## Relationships and business rules

- Each traveller email address is unique in the exercise dataset.
- Every scheduled flight has a departure and arrival airport.
- A scheduled flight must not have the same departure and arrival airport.
- Booking status is limited to pending, confirmed, or cancelled.
- Within a flight, a seat may be assigned to only one pending or confirmed booking; cancelled bookings release the seat.
- Every booking references an existing traveller.
- Every booking references an existing scheduled flight.
- Every payment references an existing booking.
- A payment amount must be greater than zero.

## Assumptions

- Booking is the root entity in the worked normalization example: traveller and flight details are stored separately and referenced by booking, without repeating ancestor roles in that example.
- Synthetic IDs are globally unique across entity tables.
- A flight number may recur at different departure times; the flight number and departure timestamp together identify a scheduled flight.
- Each booking has at most one payment record for this exercise.
- Pending and confirmed bookings hold their assigned seats; cancelled bookings do not reserve seats.
- All records are synthetic and do not represent real people, flights, or payments.

