-- Fictional sample records for Flight Booking System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."traveller" ("traveller_id", "full_name", "email", "loyalty_tier") VALUES (101, 'Avery Chen', 'avery.chen@example.test', 'silver');
INSERT INTO portfolio."traveller" ("traveller_id", "full_name", "email", "loyalty_tier") VALUES (102, 'Morgan Patel', 'morgan.patel@example.test', 'gold');
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "departure_airport", "arrival_airport", "departure_ts", "status") VALUES (201, 'NX204', 'SEA', 'SFO', '2026-12-01T08:30:00Z', 'scheduled');
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "departure_airport", "arrival_airport", "departure_ts", "status") VALUES (202, 'NX318', 'SFO', 'LAX', '2026-12-01T12:15:00+00:00', 'scheduled');
INSERT INTO portfolio."booking" ("booking_id", "traveller_id", "flight_id", "seat_code", "booking_status", "booked_ts") VALUES (301, 101, 201, '12A', 'confirmed', '2026-11-01T09:00:00Z');
INSERT INTO portfolio."booking" ("booking_id", "traveller_id", "flight_id", "seat_code", "booking_status", "booked_ts") VALUES (302, 102, 201, '12B', 'pending', '2026-11-02T10:15:00Z');
INSERT INTO portfolio."booking" ("booking_id", "traveller_id", "flight_id", "seat_code", "booking_status", "booked_ts") VALUES (303, 101, 202, '12A', 'confirmed', '2026-11-03T11:30:00Z');
INSERT INTO portfolio."payment" ("payment_id", "booking_id", "amount", "currency", "payment_status", "paid_ts") VALUES (401, 301, 149.5, 'USD', 'captured', '2026-11-01T09:05:00Z');
INSERT INTO portfolio."payment" ("payment_id", "booking_id", "amount", "currency", "payment_status", "paid_ts") VALUES (402, 302, 89.99, 'USD', 'authorized', '2026-11-02T10:20:00Z');
COMMIT;
