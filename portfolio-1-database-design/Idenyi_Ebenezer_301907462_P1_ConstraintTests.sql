-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. candidate pk. Expected: pk_candidate, SQLSTATE 23505.
INSERT INTO portfolio."candidate" ("candidate_id", "candidate_ref", "created_at")
VALUES (101, 'synthetic-candidate-new', '2026-01-11T09:00:00Z');

-- 2. candidate unique. Expected: uq_candidate_0, SQLSTATE 23505.
INSERT INTO portfolio."candidate" ("candidate_id", "candidate_ref", "created_at")
VALUES (9201, 'synthetic-candidate-a', '2026-01-11T09:00:00Z');

-- 3. candidate not null. Expected: candidate_ref, SQLSTATE 23502.
INSERT INTO portfolio."candidate" ("candidate_id", "candidate_ref", "created_at")
VALUES (9202, NULL, '2026-01-11T09:00:00Z');

-- 4. exam pk. Expected: pk_exam, SQLSTATE 23505.
INSERT INTO portfolio."exam" ("exam_id", "title", "opens_at", "closes_at", "duration_minutes")
VALUES (201, 'Duplicate-key test exam', '2026-03-01T09:00:00Z', '2026-03-01T12:00:00Z', 45);

-- 5. exam check. Expected: exam_window_check, SQLSTATE 23514.
INSERT INTO portfolio."exam" ("exam_id", "title", "opens_at", "closes_at", "duration_minutes")
VALUES (9203, 'Invalid window test', '2026-03-01T12:00:00Z', '2026-03-01T09:00:00Z', 45);

-- 6. attempt pk. Expected: pk_attempt, SQLSTATE 23505.
INSERT INTO portfolio."attempt" ("attempt_id", "candidate_id", "exam_id", "started_at", "submitted_at", "status")
VALUES (301, 101, 201, '2026-02-01T09:30:00Z', '2026-02-01T10:00:00Z', 'submitted');

-- 7. attempt candidate fk. Expected: fk_attempt_0, SQLSTATE 23503.
INSERT INTO portfolio."attempt" ("attempt_id", "candidate_id", "exam_id", "started_at", "submitted_at", "status")
VALUES (9204, 99996, 201, '2026-02-01T09:30:00Z', '2026-02-01T10:00:00Z', 'submitted');

-- 8. attempt exam fk. Expected: fk_attempt_1, SQLSTATE 23503.
INSERT INTO portfolio."attempt" ("attempt_id", "candidate_id", "exam_id", "started_at", "submitted_at", "status")
VALUES (9205, 101, 99995, '2026-02-01T09:30:00Z', '2026-02-01T10:00:00Z', 'submitted');

-- 9. attempt check. Expected: attempt_status_check, SQLSTATE 23514.
INSERT INTO portfolio."attempt" ("attempt_id", "candidate_id", "exam_id", "started_at", "submitted_at", "status")
VALUES (9206, 101, 201, '2026-02-01T09:30:00Z', NULL, 'paused');

-- 10. attempt partial unique. Expected: active_attempt_unique, SQLSTATE 23505.
INSERT INTO portfolio."attempt" ("attempt_id", "candidate_id", "exam_id", "started_at", "submitted_at", "status")
VALUES (9207, 101, 201, '2026-02-01T09:30:00Z', NULL, 'in_progress');

-- 11. question pk. Expected: pk_question, SQLSTATE 23505.
INSERT INTO portfolio."question" ("question_id", "exam_id", "prompt", "position", "points")
VALUES (401, 201, 'Duplicate-key test question', 2, 1);

-- 12. question unique. Expected: uq_question_0, SQLSTATE 23505.
INSERT INTO portfolio."question" ("question_id", "exam_id", "prompt", "position", "points")
VALUES (9208, 201, 'Duplicate position test', 1, 1);

-- 13. question exam fk. Expected: fk_question_0, SQLSTATE 23503.
INSERT INTO portfolio."question" ("question_id", "exam_id", "prompt", "position", "points")
VALUES (9209, 99994, 'Invalid exam reference test', 2, 1);

-- 14. question check. Expected: question_points_check, SQLSTATE 23514.
INSERT INTO portfolio."question" ("question_id", "exam_id", "prompt", "position", "points")
VALUES (9210, 201, 'Invalid points test', 2, 0);

-- 15. answer pk. Expected: pk_answer, SQLSTATE 23505.
INSERT INTO portfolio."answer" ("answer_id", "attempt_id", "question_id", "selected_option", "answered_at")
VALUES (501, 301, 401, 'option-b', '2026-02-01T09:50:00Z');

-- 16. answer unique. Expected: uq_answer_0, SQLSTATE 23505.
INSERT INTO portfolio."answer" ("answer_id", "attempt_id", "question_id", "selected_option", "answered_at")
VALUES (9211, 302, 401, 'option-b', '2026-02-01T09:50:00Z');

-- 17. answer attempt fk. Expected: fk_answer_0, SQLSTATE 23503.
INSERT INTO portfolio."answer" ("answer_id", "attempt_id", "question_id", "selected_option", "answered_at")
VALUES (9212, 99993, 401, 'option-b', '2026-02-01T09:50:00Z');

-- 18. answer question fk. Expected: fk_answer_1, SQLSTATE 23503.
INSERT INTO portfolio."answer" ("answer_id", "attempt_id", "question_id", "selected_option", "answered_at")
VALUES (9213, 301, 99992, 'option-b', '2026-02-01T09:50:00Z');
