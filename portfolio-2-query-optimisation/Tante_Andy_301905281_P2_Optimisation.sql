-- A separate performance table using the case's booking.booking_status type.
-- Only this field and a lab row ID are copied. Business constraints stay in Portfolio 1.
-- Generated values are for measuring a selective lookup, not complete case records.
CREATE SCHEMA query_lab;
CREATE TABLE query_lab."booking" AS
SELECT "booking_status", 0::bigint AS "lab_row_id" FROM portfolio."booking" WITH NO DATA;
INSERT INTO query_lab."booking" ("booking_status", "lab_row_id")
SELECT ('value-' || (g % 1000)::text), g FROM generate_series(1, 30000) AS g;
ANALYZE query_lab."booking";

-- Before: warm the lookup, then measure it three times.
SELECT "lab_row_id", "booking_status"
FROM query_lab."booking"
WHERE "booking_status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "booking_status"
FROM query_lab."booking"
WHERE "booking_status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "booking_status"
FROM query_lab."booking"
WHERE "booking_status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "booking_status"
FROM query_lab."booking"
WHERE "booking_status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";

CREATE INDEX p2_filter_idx ON query_lab."booking" USING btree ("booking_status");

-- After: run the same lookup and repeat the measurements.
SELECT "lab_row_id", "booking_status"
FROM query_lab."booking"
WHERE "booking_status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "booking_status"
FROM query_lab."booking"
WHERE "booking_status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "booking_status"
FROM query_lab."booking"
WHERE "booking_status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "booking_status"
FROM query_lab."booking"
WHERE "booking_status" = ('value-' || (42 % 1000)::text)
ORDER BY "lab_row_id";
