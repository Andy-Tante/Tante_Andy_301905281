-- Flight Booking System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."traveller" (
  "traveller_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "loyalty_tier" text NOT NULL,
  CONSTRAINT "pk_traveller" PRIMARY KEY ("traveller_id"),
  CONSTRAINT "uq_traveller_0" UNIQUE ("email")
);
CREATE TABLE portfolio."flight" (
  "flight_id" bigint NOT NULL,
  "flight_number" text NOT NULL,
  "departure_airport" text NOT NULL,
  "arrival_airport" text NOT NULL,
  "departure_ts" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_flight" PRIMARY KEY ("flight_id"),
  CONSTRAINT "uq_flight_0" UNIQUE ("flight_number", "departure_ts")
);
CREATE TABLE portfolio."booking" (
  "booking_id" bigint NOT NULL,
  "traveller_id" bigint NOT NULL,
  "flight_id" bigint NOT NULL,
  "seat_code" text NOT NULL,
  "booking_status" text NOT NULL,
  "booked_ts" timestamptz NOT NULL,
  CONSTRAINT "pk_booking" PRIMARY KEY ("booking_id")
);
CREATE TABLE portfolio."payment" (
  "payment_id" bigint NOT NULL,
  "booking_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "currency" text NOT NULL,
  "payment_status" text NOT NULL,
  "paid_ts" timestamptz NOT NULL,
  CONSTRAINT "pk_payment" PRIMARY KEY ("payment_id"),
  CONSTRAINT "uq_payment_0" UNIQUE ("booking_id")
);
ALTER TABLE portfolio."booking" ADD CONSTRAINT "fk_booking_0" FOREIGN KEY ("traveller_id") REFERENCES portfolio."traveller" ("traveller_id");
ALTER TABLE portfolio."booking" ADD CONSTRAINT "fk_booking_1" FOREIGN KEY ("flight_id") REFERENCES portfolio."flight" ("flight_id");
ALTER TABLE portfolio."payment" ADD CONSTRAINT "fk_payment_0" FOREIGN KEY ("booking_id") REFERENCES portfolio."booking" ("booking_id");
ALTER TABLE portfolio."flight" ADD CONSTRAINT "rule_flight_route_distinct" CHECK ((("departure_airport" = 'SEA') AND ("arrival_airport" = 'SFO')) OR (("departure_airport" = 'SEA') AND ("arrival_airport" = 'LAX')) OR (("departure_airport" = 'SFO') AND ("arrival_airport" = 'SEA')) OR (("departure_airport" = 'SFO') AND ("arrival_airport" = 'LAX')) OR (("departure_airport" = 'LAX') AND ("arrival_airport" = 'SEA')) OR (("departure_airport" = 'LAX') AND ("arrival_airport" = 'SFO')));
ALTER TABLE portfolio."booking" ADD CONSTRAINT "rule_booking_status_valid" CHECK (("booking_status" = 'pending') OR ("booking_status" = 'confirmed') OR ("booking_status" = 'cancelled'));
CREATE UNIQUE INDEX "rule_booking_active_seat_unique" ON portfolio."booking" ("flight_id", "seat_code") WHERE (("booking_status" = 'pending') OR ("booking_status" = 'confirmed'));
ALTER TABLE portfolio."payment" ADD CONSTRAINT "rule_payment_amount_positive" CHECK ("amount" > 0);
COMMIT;
