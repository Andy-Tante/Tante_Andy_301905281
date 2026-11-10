# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection flight_events for booking_created and seat_assigned events. These are fictional event examples based on booking, flight, payment.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related flight details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "booking_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "payment",
        "key": {
            "payment_id": 401
        },
        "snapshot": {
            "payment_id": 401,
            "booking_id": 301,
            "amount": 149.5,
            "currency": "USD",
            "payment_status": "captured",
            "paid_ts": "2026-11-01T09:05:00Z"
        }
    },
    "embedded": {
        "flight": [
            {
                "key": {
                    "flight_id": 201
                },
                "snapshot": {
                    "flight_id": 201,
                    "flight_number": "NX204",
                    "departure_airport": "SEA",
                    "arrival_airport": "SFO",
                    "departure_ts": "2026-12-01T08:30:00Z",
                    "status": "scheduled"
                },
                "via": [
                    "payment.booking_id → booking.flight_id → flight"
                ]
            }
        ]
    },
    "references": {
        "booking": [
            {
                "key": {
                    "booking_id": 301
                },
                "via": [
                    "payment.booking_id → booking"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("flight_events").find({"eventType":"booking_created"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "booking_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "payment_id": 401
    }
  },
  {
    "_id": "event_000003",
    "eventType": "booking_created",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "payment_id": 402
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("flight_events").find({"source.key.payment_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "booking_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "payment_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "seat_assigned",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "payment_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("flight_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "booking_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "payment_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "seat_assigned",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "payment_id": 401
    }
  },
  {
    "_id": "event_000003",
    "eventType": "booking_created",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "payment_id": 402
    }
  },
  {
    "_id": "event_000004",
    "eventType": "seat_assigned",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "payment_id": 402
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("flight_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| booking_created | 2 |
| seat_assigned | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Tante_Andy_301905281_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Tante_Andy_301905281_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

