# Online Examination System — ER diagram

```mermaid
erDiagram
    direction LR
    candidate {
        bigint candidate_id PK
        text candidate_ref UK
        timestamptz created_at
    }
    exam {
        bigint exam_id PK
        text title
        timestamptz opens_at
        timestamptz closes_at
        integer duration_minutes
    }
    attempt {
        bigint attempt_id PK
        bigint candidate_id FK
        bigint exam_id FK
        timestamptz started_at
        timestamptz submitted_at "Optional"
        text status
    }
    question {
        bigint question_id PK
        bigint exam_id FK
        text prompt
        integer position
        numeric points
    }
    answer {
        bigint answer_id PK
        bigint attempt_id FK
        bigint question_id FK
        text selected_option
        timestamptz answered_at
    }
    candidate ||--o{ attempt : "candidate_id"
    exam ||--o{ attempt : "exam_id"
    exam ||--o{ question : "exam_id"
    attempt ||--o{ answer : "attempt_id"
    question ||--o{ answer : "question_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Idenyi_Ebenezer_301907462_ERDiagram.png)
