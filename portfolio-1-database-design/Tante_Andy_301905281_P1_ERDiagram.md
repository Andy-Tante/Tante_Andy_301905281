# Flight Booking System — ER diagram

```mermaid
erDiagram
    direction LR
    traveller {
        bigint traveller_id PK
        text full_name
        text email UK
        text loyalty_tier
    }
    flight {
        bigint flight_id PK
        text flight_number
        text departure_airport
        text arrival_airport
        timestamptz departure_ts
        text status
    }
    booking {
        bigint booking_id PK
        bigint traveller_id FK
        bigint flight_id FK
        text seat_code
        text booking_status
        timestamptz booked_ts
    }
    payment {
        bigint payment_id PK
        bigint booking_id FK,UK
        numeric amount
        text currency
        text payment_status
        timestamptz paid_ts
    }
    traveller ||--o{ booking : "traveller_id"
    flight ||--o{ booking : "flight_id"
    booking ||--o| payment : "booking_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Tante_Andy_301905281_ERDiagram.png)
