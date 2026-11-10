# Online Examination System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| candidate_id | attempt records (list) |
| --- | --- |
| 101 | [301,302] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| attempt.attempt_id | attempt.candidate_id | attempt.exam_id | attempt.status | candidate.candidate_id | candidate.candidate_ref | exam.exam_id | exam.title |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | in_progress | 101 | synthetic-candidate-a | 201 | Synthetic Assessment |
| 302 | 101 | 201 | submitted | 101 | synthetic-candidate-a | 201 | Synthetic Assessment |

Key: attempt_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## attempt_example

| attempt.attempt_id | attempt.candidate_id | attempt.exam_id | attempt.status | candidate.candidate_id | candidate.candidate_ref | exam.exam_id | exam.title |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | in_progress | 101 | synthetic-candidate-a | 201 | Synthetic Assessment |
| 302 | 101 | 201 | submitted | 101 | synthetic-candidate-a | 201 | Synthetic Assessment |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## candidate

| candidate_id | candidate_ref | created_at |
| --- | --- | --- |
| 101 | synthetic-candidate-a | 2026-01-10T09:00:00+00:00 |

## exam

| exam_id | title | opens_at | closes_at | duration_minutes |
| --- | --- | --- | --- | --- |
| 201 | Synthetic Assessment | 2026-02-01T09:00:00+00:00 | 2026-02-01T12:00:00+00:00 | 60 |

## attempt

| attempt_id | candidate_id | exam_id | started_at | submitted_at | status |
| --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 2026-02-01T09:15:00+00:00 | NULL | in_progress |
| 302 | 101 | 201 | 2026-02-01T09:20:00+00:00 | 2026-02-01T10:00:00+00:00 | submitted |

## question

| question_id | exam_id | prompt | position | points |
| --- | --- | --- | --- | --- |
| 401 | 201 | Synthetic question one | 1 | 2.5 |

## answer

| answer_id | attempt_id | question_id | selected_option | answered_at |
| --- | --- | --- | --- | --- |
| 501 | 302 | 401 | option-a | 2026-02-01T09:45:00+00:00 |

## Dependencies

- candidate: (candidate_id) → candidate_ref, created_at
- exam: (exam_id) → title, opens_at, closes_at, duration_minutes
- attempt: (attempt_id) → candidate_id, exam_id, started_at, submitted_at, status
- question: (question_id) → exam_id, prompt, position, points
- answer: (answer_id) → attempt_id, question_id, selected_option, answered_at

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
