-- Fictional sample records for Online Examination System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."candidate" ("candidate_id", "candidate_ref", "created_at") VALUES (101, 'synthetic-candidate-a', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."exam" ("exam_id", "title", "opens_at", "closes_at", "duration_minutes") VALUES (201, 'Synthetic Assessment', '2026-02-01T09:00:00Z', '2026-02-01T12:00:00Z', 60);
INSERT INTO portfolio."attempt" ("attempt_id", "candidate_id", "exam_id", "started_at", "submitted_at", "status") VALUES (301, 101, 201, '2026-02-01T09:15:00Z', NULL, 'in_progress');
INSERT INTO portfolio."attempt" ("attempt_id", "candidate_id", "exam_id", "started_at", "submitted_at", "status") VALUES (302, 101, 201, '2026-02-01T09:20:00Z', '2026-02-01T10:00:00Z', 'submitted');
INSERT INTO portfolio."question" ("question_id", "exam_id", "prompt", "position", "points") VALUES (401, 201, 'Synthetic question one', 1, 2.5);
INSERT INTO portfolio."answer" ("answer_id", "attempt_id", "question_id", "selected_option", "answered_at") VALUES (501, 302, 401, 'option-a', '2026-02-01T09:45:00Z');
COMMIT;
