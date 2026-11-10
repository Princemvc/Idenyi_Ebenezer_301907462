# Online Examination System — Database Design

My case study will records candidate, exam, attempt, question, answer.

## The Users

- Candidates taking scheduled exams
- Exam staff creating exams and reviewing results

## Main operations

- Create an exam and its questions
- Start and submit a candidate exam attempt
- Review submitted attempts and aggregate scores

## Entities

| Entity | Information stored |
| --- | --- |
| candidate | Stores a pseudonymous candidate reference without names or supplied student IDs. |
| exam | Defines an exam's title, availability window, and duration. |
| attempt | Records one candidate's attempt at one exam. Its foreign keys connect to candidate and exam without copying their descriptive attributes. |
| question | Stores exam questions, their ordering, and the points available for each question. |
| answer | Records a response to one question within one attempt. |

## candidate

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| candidate_id | BIGINT | PK | Yes |
| candidate_ref | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (candidate_ref).

## exam

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| exam_id | BIGINT | PK | Yes |
| title | TEXT |  | Yes |
| opens_at | TIMESTAMPTZ |  | Yes |
| closes_at | TIMESTAMPTZ |  | Yes |
| duration_minutes | INTEGER |  | Yes |


## attempt

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| attempt_id | BIGINT | PK | Yes |
| candidate_id | BIGINT | FK | Yes |
| exam_id | BIGINT | FK | Yes |
| started_at | TIMESTAMPTZ |  | Yes |
| submitted_at | TIMESTAMPTZ |  | No |
| status | TEXT |  | Yes |
- candidate_id → candidate.candidate_id
- exam_id → exam.exam_id

## question

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| question_id | BIGINT | PK | Yes |
| exam_id | BIGINT | FK | Yes |
| prompt | TEXT |  | Yes |
| position | INTEGER |  | Yes |
| points | NUMERIC(18,2) |  | Yes |
- exam_id → exam.exam_id
- Unique key: (exam_id, position).

## answer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| answer_id | BIGINT | PK | Yes |
| attempt_id | BIGINT | FK | Yes |
| question_id | BIGINT | FK | Yes |
| selected_option | TEXT |  | Yes |
| answered_at | TIMESTAMPTZ |  | Yes |
- attempt_id → attempt.attempt_id
- question_id → question.question_id
- Unique key: (attempt_id, question_id).

## Relationships and business rules

- Every pseudonymous candidate reference must be unique.
- An exam must close after it opens, and its duration must be positive.
- Each attempt must reference an existing candidate.
- Each attempt must reference an existing exam.
- Attempt status is limited to in_progress or submitted; submitted attempts require a submission timestamp.
- At most one attempt for a candidate and exam may have status in_progress.
- Question positions are unique within each exam.
- Question position and available points must be positive.
- Each answer must reference an existing attempt.
- Each answer must reference an existing question.
- An attempt can have at most one answer row for a given question.

## Assumptions

- Candidate references are synthetic pseudonymous keys; no student names or actual student identifiers are modeled or supplied.
- Each attempt belongs to one candidate and one exam. Attempt is the normalization example root: it stores candidate_id and exam_id foreign keys, while candidate and exam descriptive attributes stay in their respective tables.
- An attempt is active while its status is in_progress; a candidate may have at most one active attempt for the same exam.
- Only submitted attempts are included in result aggregates; scores are derived from answer and question points rather than stored redundantly.
- An answer row represents a recorded response to one question in one attempt; unanswered questions have no answer row.
- All records used for exercises and benchmarks are synthetic.

