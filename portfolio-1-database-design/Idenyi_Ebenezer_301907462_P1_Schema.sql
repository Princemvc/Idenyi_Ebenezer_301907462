-- Online Examination System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."candidate" (
  "candidate_id" bigint NOT NULL,
  "candidate_ref" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_candidate" PRIMARY KEY ("candidate_id"),
  CONSTRAINT "uq_candidate_0" UNIQUE ("candidate_ref")
);
CREATE TABLE portfolio."exam" (
  "exam_id" bigint NOT NULL,
  "title" text NOT NULL,
  "opens_at" timestamptz NOT NULL,
  "closes_at" timestamptz NOT NULL,
  "duration_minutes" bigint NOT NULL,
  CONSTRAINT "pk_exam" PRIMARY KEY ("exam_id")
);
CREATE TABLE portfolio."attempt" (
  "attempt_id" bigint NOT NULL,
  "candidate_id" bigint NOT NULL,
  "exam_id" bigint NOT NULL,
  "started_at" timestamptz NOT NULL,
  "submitted_at" timestamptz,
  "status" text NOT NULL,
  CONSTRAINT "pk_attempt" PRIMARY KEY ("attempt_id")
);
CREATE TABLE portfolio."question" (
  "question_id" bigint NOT NULL,
  "exam_id" bigint NOT NULL,
  "prompt" text NOT NULL,
  "position" bigint NOT NULL,
  "points" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_question" PRIMARY KEY ("question_id"),
  CONSTRAINT "uq_question_0" UNIQUE ("exam_id", "position")
);
CREATE TABLE portfolio."answer" (
  "answer_id" bigint NOT NULL,
  "attempt_id" bigint NOT NULL,
  "question_id" bigint NOT NULL,
  "selected_option" text NOT NULL,
  "answered_at" timestamptz NOT NULL,
  CONSTRAINT "pk_answer" PRIMARY KEY ("answer_id"),
  CONSTRAINT "uq_answer_0" UNIQUE ("attempt_id", "question_id")
);
ALTER TABLE portfolio."attempt" ADD CONSTRAINT "fk_attempt_0" FOREIGN KEY ("candidate_id") REFERENCES portfolio."candidate" ("candidate_id");
ALTER TABLE portfolio."attempt" ADD CONSTRAINT "fk_attempt_1" FOREIGN KEY ("exam_id") REFERENCES portfolio."exam" ("exam_id");
ALTER TABLE portfolio."question" ADD CONSTRAINT "fk_question_0" FOREIGN KEY ("exam_id") REFERENCES portfolio."exam" ("exam_id");
ALTER TABLE portfolio."answer" ADD CONSTRAINT "fk_answer_0" FOREIGN KEY ("attempt_id") REFERENCES portfolio."attempt" ("attempt_id");
ALTER TABLE portfolio."answer" ADD CONSTRAINT "fk_answer_1" FOREIGN KEY ("question_id") REFERENCES portfolio."question" ("question_id");
ALTER TABLE portfolio."exam" ADD CONSTRAINT "exam_window_check" CHECK (("closes_at" > "opens_at") AND ("duration_minutes" > 0));
ALTER TABLE portfolio."attempt" ADD CONSTRAINT "attempt_status_check" CHECK (("status" = 'in_progress') OR (("status" = 'submitted') AND ("submitted_at" IS NOT NULL)));
CREATE UNIQUE INDEX "active_attempt_unique" ON portfolio."attempt" ("candidate_id", "exam_id") WHERE ("status" = 'in_progress');
ALTER TABLE portfolio."question" ADD CONSTRAINT "question_points_check" CHECK (("position" > 0) AND ("points" > 0));
COMMIT;
