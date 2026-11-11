# The Online Examination System — SQL queries

## 1. This show related attempt, candidate, exam records (up to 20).

```sql
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
```

| attempt_attempt_id | attempt_started_at | candidate_candidate_id | candidate_candidate_ref | exam_exam_id | exam_title |
| --- | --- | --- | --- | --- | --- |
| 301 | 2026-02-01T09:15:00+00:00 | 101 | synthetic-candidate-a | 201 | Synthetic Assessment |
| 302 | 2026-02-01T09:20:00+00:00 | 101 | synthetic-candidate-a | 201 | Synthetic Assessment |

## 2. Find exam records where title matches "Synthetic Assessment" (up to 20).

```sql
SELECT * FROM portfolio."exam"
WHERE "title" IS NOT DISTINCT FROM 'Synthetic Assessment'
ORDER BY "exam_id"
LIMIT 20;
```

| exam_id | title | opens_at | closes_at | duration_minutes |
| --- | --- | --- | --- | --- |
| 201 | Synthetic Assessment | 2026-02-01T09:00:00+00:00 | 2026-02-01T12:00:00+00:00 | 60 |

## 3. Count question records for each exam_id (up to 20 groups).

```sql
SELECT "exam_id", count(*) AS record_count
FROM portfolio."question"
GROUP BY "exam_id"
ORDER BY record_count DESC, "exam_id" NULLS LAST
LIMIT 20;
```

| exam_id | record_count |
| --- | --- |
| 201 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.205 | 1.189, 1.21, 1.205 | Sort → Seq Scan | 131 |
| After index | 0.197 | 0.194, 0.2, 0.197 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.205 ms to 0.197 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.159..1.161 rows=20 loops=1)
  Seq Scan on attempt (actual time=0.018..1.123 rows=20 loops=1)
Planning Time: 0.409 ms
Execution Time: 1.189 ms
```

### Before index, run 2

```text
Sort (actual time=1.181..1.183 rows=20 loops=1)
  Seq Scan on attempt (actual time=0.018..1.145 rows=20 loops=1)
Planning Time: 0.424 ms
Execution Time: 1.21 ms
```

### Before index, run 3

```text
Sort (actual time=1.178..1.179 rows=20 loops=1)
  Seq Scan on attempt (actual time=0.018..1.113 rows=20 loops=1)
Planning Time: 0.415 ms
Execution Time: 1.205 ms
```

### After index, run 1

```text
Sort (actual time=0.145..0.147 rows=20 loops=1)
  Bitmap Heap Scan on attempt (actual time=0.027..0.108 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.018 rows=20 loops=1)
Planning Time: 0.656 ms
Execution Time: 0.194 ms
```

### After index, run 2

```text
Sort (actual time=0.148..0.149 rows=20 loops=1)
  Bitmap Heap Scan on attempt (actual time=0.026..0.108 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.639 ms
Execution Time: 0.2 ms
```

### After index, run 3

```text
Sort (actual time=0.146..0.148 rows=20 loops=1)
  Bitmap Heap Scan on attempt (actual time=0.027..0.108 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.018 rows=20 loops=1)
Planning Time: 0.634 ms
Execution Time: 0.197 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Idenyi_Ebenezer_301907462_P2_Queries.sql, then Idenyi_Ebenezer_301907462_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Idenyi_Ebenezer_301907462_P2_QueryResults.png) · [Index comparison](screenshots/Idenyi_Ebenezer_301907462_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

