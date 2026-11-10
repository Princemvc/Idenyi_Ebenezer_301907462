// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("attempt_event_streams")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("attempt_event_streams", {
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
                    "attempt_started",
                    "answer_recorded"
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
                            "answer"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "answer_id"
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
  printjson(await db.getCollection("attempt_event_streams").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "attempt_started",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "answer",
            "key": {
                "answer_id": 501
            },
            "snapshot": {
                "answer_id": 501,
                "attempt_id": 302,
                "question_id": 401,
                "selected_option": "option-a",
                "answered_at": "2026-02-01T09:45:00Z"
            }
        },
        "embedded": {
            "exam": [
                {
                    "key": {
                        "exam_id": 201
                    },
                    "snapshot": {
                        "exam_id": 201,
                        "title": "Synthetic Assessment",
                        "opens_at": "2026-02-01T09:00:00Z",
                        "closes_at": "2026-02-01T12:00:00Z",
                        "duration_minutes": 60
                    },
                    "via": [
                        "answer.attempt_id → attempt.exam_id → exam",
                        "answer.question_id → question.exam_id → exam"
                    ]
                }
            ]
        },
        "references": {
            "attempt": [
                {
                    "key": {
                        "attempt_id": 302
                    },
                    "via": [
                        "answer.attempt_id → attempt"
                    ]
                }
            ],
            "candidate": [
                {
                    "key": {
                        "candidate_id": 101
                    },
                    "via": [
                        "answer.attempt_id → attempt.candidate_id → candidate"
                    ]
                }
            ],
            "question": [
                {
                    "key": {
                        "question_id": 401
                    },
                    "via": [
                        "answer.question_id → question"
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
        "eventType": "answer_recorded",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "answer",
            "key": {
                "answer_id": 501
            },
            "snapshot": {
                "answer_id": 501,
                "attempt_id": 302,
                "question_id": 401,
                "selected_option": "option-a",
                "answered_at": "2026-02-01T09:45:00Z"
            }
        },
        "embedded": {
            "exam": [
                {
                    "key": {
                        "exam_id": 201
                    },
                    "snapshot": {
                        "exam_id": 201,
                        "title": "Synthetic Assessment",
                        "opens_at": "2026-02-01T09:00:00Z",
                        "closes_at": "2026-02-01T12:00:00Z",
                        "duration_minutes": 60
                    },
                    "via": [
                        "answer.attempt_id → attempt.exam_id → exam",
                        "answer.question_id → question.exam_id → exam"
                    ]
                }
            ]
        },
        "references": {
            "attempt": [
                {
                    "key": {
                        "attempt_id": 302
                    },
                    "via": [
                        "answer.attempt_id → attempt"
                    ]
                }
            ],
            "candidate": [
                {
                    "key": {
                        "candidate_id": 101
                    },
                    "via": [
                        "answer.attempt_id → attempt.candidate_id → candidate"
                    ]
                }
            ],
            "question": [
                {
                    "key": {
                        "question_id": 401
                    },
                    "via": [
                        "answer.question_id → question"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "answer",
                    "key": {
                        "answer_id": 501
                    },
                    "field": "selected_option",
                    "value": "option-a"
                }
            ],
            "examples": {
                "client_metadata": "illustrative client_metadata",
                "event_payload": "illustrative event_payload"
            }
        }
    }
]));
  await db.getCollection("attempt_event_streams").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("attempt_event_streams").find({"eventType":"attempt_started"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("attempt_event_streams").find({"source.key.answer_id":501}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("attempt_event_streams").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("attempt_event_streams").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("attempt_event_streams").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "attempt_started",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "answer",
        "key": {
            "answer_id": 501
        },
        "snapshot": {
            "answer_id": 501,
            "attempt_id": 302,
            "question_id": 401,
            "selected_option": "option-a",
            "answered_at": "2026-02-01T09:45:00Z"
        }
    },
    "embedded": {
        "exam": [
            {
                "key": {
                    "exam_id": 201
                },
                "snapshot": {
                    "exam_id": 201,
                    "title": "Synthetic Assessment",
                    "opens_at": "2026-02-01T09:00:00Z",
                    "closes_at": "2026-02-01T12:00:00Z",
                    "duration_minutes": 60
                },
                "via": [
                    "answer.attempt_id → attempt.exam_id → exam",
                    "answer.question_id → question.exam_id → exam"
                ]
            }
        ]
    },
    "references": {
        "attempt": [
            {
                "key": {
                    "attempt_id": 302
                },
                "via": [
                    "answer.attempt_id → attempt"
                ]
            }
        ],
        "candidate": [
            {
                "key": {
                    "candidate_id": 101
                },
                "via": [
                    "answer.attempt_id → attempt.candidate_id → candidate"
                ]
            }
        ],
        "question": [
            {
                "key": {
                    "question_id": 401
                },
                "via": [
                    "answer.question_id → question"
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
  try { await db.getCollection("attempt_event_streams").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "attempt_started",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "answer",
        "key": {
            "answer_id": 501
        },
        "snapshot": {
            "answer_id": 501,
            "attempt_id": 302,
            "question_id": 401,
            "selected_option": "option-a",
            "answered_at": "2026-02-01T09:45:00Z"
        }
    },
    "embedded": {
        "exam": [
            {
                "key": {
                    "exam_id": 201
                },
                "snapshot": {
                    "exam_id": 201,
                    "title": "Synthetic Assessment",
                    "opens_at": "2026-02-01T09:00:00Z",
                    "closes_at": "2026-02-01T12:00:00Z",
                    "duration_minutes": 60
                },
                "via": [
                    "answer.attempt_id → attempt.exam_id → exam",
                    "answer.question_id → question.exam_id → exam"
                ]
            }
        ]
    },
    "references": {
        "attempt": [
            {
                "key": {
                    "attempt_id": 302
                },
                "via": [
                    "answer.attempt_id → attempt"
                ]
            }
        ],
        "candidate": [
            {
                "key": {
                    "candidate_id": 101
                },
                "via": [
                    "answer.attempt_id → attempt.candidate_id → candidate"
                ]
            }
        ],
        "question": [
            {
                "key": {
                    "question_id": 401
                },
                "via": [
                    "answer.question_id → question"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("attempt_event_streams").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
