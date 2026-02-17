-- sql/duckdb/owens_library_query_checkouts_aggregate.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Summarize overall checkout fine activity across ALL branches.
--
-- This query answers:
-- - "What is our total amount of fines?"
-- - "What is the average fine amount?"
--
-- WHY:
-- - Establishes system-wide performance
-- - Provides a baseline before breaking results down by store
-- - Helps answer:
--   "Is overall balance owed up or down?"

SELECT
  COUNT(*) AS checkout_count,
  ROUND(SUM(fine_amount), 2) AS total_fines,
  ROUND(AVG(fine_amount), 2) AS avg_fine_amount
FROM checkout;
