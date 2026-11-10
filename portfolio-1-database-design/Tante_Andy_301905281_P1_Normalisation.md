# Flight Booking System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| traveller_id | booking records (list) |
| --- | --- |
| 101 | [301,303] |
| 102 | [302] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| booking.booking_id | booking.traveller_id | booking.flight_id | booking.seat_code | traveller.traveller_id | traveller.full_name | flight.flight_id | flight.flight_number |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 12A | 101 | Avery Chen | 201 | NX204 |
| 302 | 102 | 201 | 12B | 102 | Morgan Patel | 201 | NX204 |
| 303 | 101 | 202 | 12A | 101 | Avery Chen | 202 | NX318 |

Key: booking_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## booking_example

| booking.booking_id | booking.traveller_id | booking.flight_id | booking.seat_code | traveller.traveller_id | traveller.full_name | flight.flight_id | flight.flight_number |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 12A | 101 | Avery Chen | 201 | NX204 |
| 302 | 102 | 201 | 12B | 102 | Morgan Patel | 201 | NX204 |
| 303 | 101 | 202 | 12A | 101 | Avery Chen | 202 | NX318 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## traveller

| traveller_id | full_name | email | loyalty_tier |
| --- | --- | --- | --- |
| 101 | Avery Chen | avery.chen@example.test | silver |
| 102 | Morgan Patel | morgan.patel@example.test | gold |

## flight

| flight_id | flight_number | departure_airport | arrival_airport | departure_ts | status |
| --- | --- | --- | --- | --- | --- |
| 201 | NX204 | SEA | SFO | 2026-12-01T08:30:00+00:00 | scheduled |
| 202 | NX318 | SFO | LAX | 2026-12-01T12:15:00+00:00 | scheduled |

## booking

| booking_id | traveller_id | flight_id | seat_code | booking_status | booked_ts |
| --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 12A | confirmed | 2026-11-01T09:00:00+00:00 |
| 302 | 102 | 201 | 12B | pending | 2026-11-02T10:15:00+00:00 |
| 303 | 101 | 202 | 12A | confirmed | 2026-11-03T11:30:00+00:00 |

## payment

| payment_id | booking_id | amount | currency | payment_status | paid_ts |
| --- | --- | --- | --- | --- | --- |
| 401 | 301 | 149.5 | USD | captured | 2026-11-01T09:05:00+00:00 |
| 402 | 302 | 89.99 | USD | authorized | 2026-11-02T10:20:00+00:00 |

## Dependencies

- traveller: (traveller_id) → full_name, email, loyalty_tier
- flight: (flight_id) → flight_number, departure_airport, arrival_airport, departure_ts, status
- booking: (booking_id) → traveller_id, flight_id, seat_code, booking_status, booked_ts
- payment: (payment_id) → booking_id, amount, currency, payment_status, paid_ts

Joining the decomposed sample tables reproduces the original 3 example rows. The design assumes the declared keys describe the relevant business dependencies.
