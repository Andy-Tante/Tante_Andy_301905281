# Flight Booking System — SQL queries

## 1. Show related booking, flight, traveller records (up to 20).

```sql
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
```

| booking_booking_id | booking_seat_code | flight_flight_id | flight_flight_number | traveller_traveller_id | traveller_full_name |
| --- | --- | --- | --- | --- | --- |
| 301 | 12A | 201 | NX204 | 101 | Avery Chen |
| 302 | 12B | 201 | NX204 | 102 | Morgan Patel |
| 303 | 12A | 202 | NX318 | 101 | Avery Chen |

## 2. Find booking records where booking_status matches "confirmed" (up to 20).

```sql
SELECT * FROM portfolio."booking"
WHERE "booking_status" IS NOT DISTINCT FROM 'confirmed'
ORDER BY "booking_id"
LIMIT 20;
```

| booking_id | traveller_id | flight_id | seat_code | booking_status | booked_ts |
| --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 12A | confirmed | 2026-11-01T09:00:00+00:00 |
| 303 | 101 | 202 | 12A | confirmed | 2026-11-03T11:30:00+00:00 |

## 3. Count payment records for each booking_id (up to 20 groups).

```sql
SELECT "booking_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "booking_id"
ORDER BY record_count DESC, "booking_id" NULLS LAST
LIMIT 20;
```

| booking_id | record_count |
| --- | --- |
| 301 | 1 |
| 302 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.607 | 3.226, 1.607, 1.604 | Sort → Seq Scan | 194 |
| After index | 0.22 | 0.217, 0.22, 1.031 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 35 |

The median execution time changed from 1.607 ms to 0.22 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=3.191..3.194 rows=30 loops=1)
  Seq Scan on booking (actual time=0.024..3.136 rows=30 loops=1)
Planning Time: 0.542 ms
Execution Time: 3.226 ms
```

### Before index, run 2

```text
Sort (actual time=1.577..1.579 rows=30 loops=1)
  Seq Scan on booking (actual time=0.016..1.539 rows=30 loops=1)
Planning Time: 0.366 ms
Execution Time: 1.607 ms
```

### Before index, run 3

```text
Sort (actual time=1.577..1.579 rows=30 loops=1)
  Seq Scan on booking (actual time=0.017..1.54 rows=30 loops=1)
Planning Time: 0.369 ms
Execution Time: 1.604 ms
```

### After index, run 1

```text
Sort (actual time=0.169..0.17 rows=30 loops=1)
  Bitmap Heap Scan on booking (actual time=0.024..0.128 rows=30 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=30 loops=1)
Planning Time: 0.588 ms
Execution Time: 0.217 ms
```

### After index, run 2

```text
Sort (actual time=0.175..0.177 rows=30 loops=1)
  Bitmap Heap Scan on booking (actual time=0.024..0.138 rows=30 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=30 loops=1)
Planning Time: 0.607 ms
Execution Time: 0.22 ms
```

### After index, run 3

```text
Sort (actual time=0.975..0.977 rows=30 loops=1)
  Bitmap Heap Scan on booking (actual time=0.78..0.92 rows=30 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.763..0.764 rows=30 loops=1)
Planning Time: 2.828 ms
Execution Time: 1.031 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Tante_Andy_301905281_P2_Queries.sql, then Tante_Andy_301905281_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Tante_Andy_301905281_P2_QueryResults.png) · [Index comparison](screenshots/Tante_Andy_301905281_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

