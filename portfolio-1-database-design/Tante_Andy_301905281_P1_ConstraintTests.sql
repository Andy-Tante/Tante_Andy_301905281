-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. test traveller pk. Expected: pk_traveller, SQLSTATE 23505.
INSERT INTO portfolio."traveller" ("traveller_id", "full_name", "email", "loyalty_tier")
VALUES (101, 'Jordan Lee', 'jordan.lee@example.test', 'silver');

-- 2. test traveller unique. Expected: uq_traveller_0, SQLSTATE 23505.
INSERT INTO portfolio."traveller" ("traveller_id", "full_name", "email", "loyalty_tier")
VALUES (501, 'Jordan Lee', 'avery.chen@example.test', 'silver');

-- 3. test traveller not null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."traveller" ("traveller_id", "full_name", "email", "loyalty_tier")
VALUES (502, NULL, 'casey.roe@example.test', 'silver');

-- 4. test flight pk. Expected: pk_flight, SQLSTATE 23505.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "departure_airport", "arrival_airport", "departure_ts", "status")
VALUES (201, 'NX999', 'SEA', 'LAX', '2026-12-02T08:30:00Z', 'scheduled');

-- 5. test flight unique. Expected: uq_flight_0, SQLSTATE 23505.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "departure_airport", "arrival_airport", "departure_ts", "status")
VALUES (503, 'NX204', 'SEA', 'LAX', '2026-12-01T08:30:00Z', 'scheduled');

-- 6. test flight route check. Expected: rule_flight_route_distinct, SQLSTATE 23514.
INSERT INTO portfolio."flight" ("flight_id", "flight_number", "departure_airport", "arrival_airport", "departure_ts", "status")
VALUES (504, 'NX777', 'SEA', 'SEA', '2026-12-03T08:30:00Z', 'scheduled');

-- 7. test booking pk. Expected: pk_booking, SQLSTATE 23505.
INSERT INTO portfolio."booking" ("booking_id", "traveller_id", "flight_id", "seat_code", "booking_status", "booked_ts")
VALUES (301, 102, 202, '18C', 'confirmed', '2026-11-04T12:00:00Z');

-- 8. test booking traveller fk. Expected: fk_booking_0, SQLSTATE 23503.
INSERT INTO portfolio."booking" ("booking_id", "traveller_id", "flight_id", "seat_code", "booking_status", "booked_ts")
VALUES (505, 999, 202, '18C', 'pending', '2026-11-04T12:00:00Z');

-- 9. test booking flight fk. Expected: fk_booking_1, SQLSTATE 23503.
INSERT INTO portfolio."booking" ("booking_id", "traveller_id", "flight_id", "seat_code", "booking_status", "booked_ts")
VALUES (506, 102, 999, '18D', 'pending', '2026-11-04T12:00:00Z');

-- 10. test booking status check. Expected: rule_booking_status_valid, SQLSTATE 23514.
INSERT INTO portfolio."booking" ("booking_id", "traveller_id", "flight_id", "seat_code", "booking_status", "booked_ts")
VALUES (507, 102, 202, '18E', 'held', '2026-11-04T12:00:00Z');

-- 11. test booking seat partial unique. Expected: rule_booking_active_seat_unique, SQLSTATE 23505.
INSERT INTO portfolio."booking" ("booking_id", "traveller_id", "flight_id", "seat_code", "booking_status", "booked_ts")
VALUES (508, 102, 201, '12A', 'confirmed', '2026-11-04T12:00:00Z');

-- 12. test payment pk. Expected: pk_payment, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "booking_id", "amount", "currency", "payment_status", "paid_ts")
VALUES (401, 303, 50, 'USD', 'captured', '2026-11-04T12:05:00Z');

-- 13. test payment unique. Expected: uq_payment_0, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "booking_id", "amount", "currency", "payment_status", "paid_ts")
VALUES (509, 301, 50, 'USD', 'captured', '2026-11-04T12:05:00Z');

-- 14. test payment booking fk. Expected: fk_payment_0, SQLSTATE 23503.
INSERT INTO portfolio."payment" ("payment_id", "booking_id", "amount", "currency", "payment_status", "paid_ts")
VALUES (510, 999, 50, 'USD', 'captured', '2026-11-04T12:05:00Z');

-- 15. test payment amount check. Expected: rule_payment_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."payment" ("payment_id", "booking_id", "amount", "currency", "payment_status", "paid_ts")
VALUES (511, 303, 0, 'USD', 'captured', '2026-11-04T12:05:00Z');
