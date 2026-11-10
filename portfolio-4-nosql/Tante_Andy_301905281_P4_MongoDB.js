// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("flight_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("flight_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "booking_created",
                    "seat_assigned"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "payment"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "payment_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("flight_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "seat_assigned",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "booking",
                    "key": {
                        "booking_id": 301
                    },
                    "field": "seat_code",
                    "value": "12A"
                },
                {
                    "entity": "booking",
                    "key": {
                        "booking_id": 301
                    },
                    "field": "booking_status",
                    "value": "confirmed"
                },
                {
                    "entity": "payment",
                    "key": {
                        "payment_id": 401
                    },
                    "field": "payment_status",
                    "value": "captured"
                }
            ],
            "examples": {
                "cancellation_reason": "illustrative cancellation_reason"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "booking_created",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "payment",
            "key": {
                "payment_id": 402
            },
            "snapshot": {
                "payment_id": 402,
                "booking_id": 302,
                "amount": 89.99,
                "currency": "USD",
                "payment_status": "authorized",
                "paid_ts": "2026-11-02T10:20:00Z"
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
                        "booking_id": 302
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "seat_assigned",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "payment",
            "key": {
                "payment_id": 402
            },
            "snapshot": {
                "payment_id": 402,
                "booking_id": 302,
                "amount": 89.99,
                "currency": "USD",
                "payment_status": "authorized",
                "paid_ts": "2026-11-02T10:20:00Z"
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
                        "booking_id": 302
                    },
                    "via": [
                        "payment.booking_id → booking"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "booking",
                    "key": {
                        "booking_id": 302
                    },
                    "field": "seat_code",
                    "value": "12B"
                },
                {
                    "entity": "booking",
                    "key": {
                        "booking_id": 302
                    },
                    "field": "booking_status",
                    "value": "pending"
                },
                {
                    "entity": "payment",
                    "key": {
                        "payment_id": 402
                    },
                    "field": "payment_status",
                    "value": "authorized"
                }
            ],
            "examples": {
                "cancellation_reason": "illustrative cancellation_reason"
            }
        }
    }
]));
  await db.getCollection("flight_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("flight_events").find({"eventType":"booking_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("flight_events").find({"source.key.payment_id":401}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("flight_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("flight_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("flight_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("flight_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("flight_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
