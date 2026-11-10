-- Show related attempt, candidate, exam records (up to 20).
SELECT t0."attempt_id" AS "attempt_attempt_id",
       t0."started_at" AS "attempt_started_at",
       t1."candidate_id" AS "candidate_candidate_id",
       t1."candidate_ref" AS "candidate_candidate_ref",
       t2."exam_id" AS "exam_exam_id",
       t2."title" AS "exam_title"
FROM portfolio."attempt" t0
JOIN portfolio."candidate" t1 ON t0."candidate_id" = t1."candidate_id"
JOIN portfolio."exam" t2 ON t0."exam_id" = t2."exam_id"
ORDER BY t0."attempt_id", t1."candidate_id", t2."exam_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."attempt_id" AS "attempt_attempt_id",
       t0."started_at" AS "attempt_started_at",
       t1."candidate_id" AS "candidate_candidate_id",
       t1."candidate_ref" AS "candidate_candidate_ref",
       t2."exam_id" AS "exam_exam_id",
       t2."title" AS "exam_title"
FROM portfolio."attempt" t0
JOIN portfolio."candidate" t1 ON t0."candidate_id" = t1."candidate_id"
JOIN portfolio."exam" t2 ON t0."exam_id" = t2."exam_id"
ORDER BY t0."attempt_id", t1."candidate_id", t2."exam_id"
LIMIT 20;

-- Find exam records where title matches "Synthetic Assessment" (up to 20).
SELECT * FROM portfolio."exam"
WHERE "title" IS NOT DISTINCT FROM 'Synthetic Assessment'
ORDER BY "exam_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."exam"
WHERE "title" IS NOT DISTINCT FROM 'Synthetic Assessment'
ORDER BY "exam_id"
LIMIT 20;

-- Count question records for each exam_id (up to 20 groups).
SELECT "exam_id", count(*) AS record_count
FROM portfolio."question"
GROUP BY "exam_id"
ORDER BY record_count DESC, "exam_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "exam_id", count(*) AS record_count
FROM portfolio."question"
GROUP BY "exam_id"
ORDER BY record_count DESC, "exam_id" NULLS LAST
LIMIT 20;
