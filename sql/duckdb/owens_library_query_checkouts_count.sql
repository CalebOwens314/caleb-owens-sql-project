-- sql/duckdb/owens_library_query_checkouts_count.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Answer a basic activity question:
-- "How many checkouts have occurred?"
--
-- This query operates on the dependent/child table.
--
-- WHY:
-- - Number of checkouts and total checkout fines are different signals
-- - A library may have many small fines or a few large ones
-- - Analysts often start by understanding event counts
--   before analyzing monetary impact

SELECT
  COUNT(*) AS checkout_count
FROM checkout;
