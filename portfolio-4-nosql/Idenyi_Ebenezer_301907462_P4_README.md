# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection attempt_event_streams for attempt_started and answer_recorded events. These are fictional event examples based on attempt, candidate, exam, question, answer.

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

Related exam details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
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
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("attempt_event_streams").find({"eventType":"attempt_started"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "attempt_started",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "answer_id": 501
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("attempt_event_streams").find({"source.key.answer_id":501}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "attempt_started",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "answer_id": 501
    }
  },
  {
    "_id": "event_000002",
    "eventType": "answer_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "answer_id": 501
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("attempt_event_streams").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "attempt_started",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "answer_id": 501
    }
  },
  {
    "_id": "event_000002",
    "eventType": "answer_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "answer_id": 501
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("attempt_event_streams").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| answer_recorded | 1 |
| attempt_started | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Idenyi_Ebenezer_301907462_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Idenyi_Ebenezer_301907462_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

