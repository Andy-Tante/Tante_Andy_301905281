-- Show related booking, flight, traveller records (up to 20).
SELECT t0."booking_id" AS "booking_booking_id",
       t0."seat_code" AS "booking_seat_code",
       t2."flight_id" AS "flight_flight_id",
       t2."flight_number" AS "flight_flight_number",
       t1."traveller_id" AS "traveller_traveller_id",
       t1."full_name" AS "traveller_full_name"
FROM portfolio."booking" t0
JOIN portfolio."traveller" t1 ON t0."traveller_id" = t1."traveller_id"
JOIN portfolio."flight" t2 ON t0."flight_id" = t2."flight_id"
ORDER BY t0."booking_id", t2."flight_id", t1."traveller_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."booking_id" AS "booking_booking_id",
       t0."seat_code" AS "booking_seat_code",
       t2."flight_id" AS "flight_flight_id",
       t2."flight_number" AS "flight_flight_number",
       t1."traveller_id" AS "traveller_traveller_id",
       t1."full_name" AS "traveller_full_name"
FROM portfolio."booking" t0
JOIN portfolio."traveller" t1 ON t0."traveller_id" = t1."traveller_id"
JOIN portfolio."flight" t2 ON t0."flight_id" = t2."flight_id"
ORDER BY t0."booking_id", t2."flight_id", t1."traveller_id"
LIMIT 20;

-- Find booking records where booking_status matches "confirmed" (up to 20).
SELECT * FROM portfolio."booking"
WHERE "booking_status" IS NOT DISTINCT FROM 'confirmed'
ORDER BY "booking_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."booking"
WHERE "booking_status" IS NOT DISTINCT FROM 'confirmed'
ORDER BY "booking_id"
LIMIT 20;

-- Count payment records for each booking_id (up to 20 groups).
SELECT "booking_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "booking_id"
ORDER BY record_count DESC, "booking_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "booking_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "booking_id"
ORDER BY record_count DESC, "booking_id" NULLS LAST
LIMIT 20;
