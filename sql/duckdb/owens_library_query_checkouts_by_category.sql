-- sql/duckdb/owens_library_query_checkouts_by_category.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Break overall checkout performance down by branch.
--
-- This query answers:
-- "How many checkouts do we have by branch?"
--
-- WHY:
-- - Overall totals hide important differences.
-- - Grouping lets us compare parts of the system.
-- - This often reveals where action is needed:
--   * Which branches drive checkout activity?
--   * Which branches underperform?
--
-- IMPORTANT:
-- This query uses GROUP BY but does NOT join tables yet.
-- We are still working only with the dependent/child table (sale).

SELECT
  material_type,
  COUNT(*) AS checkout_count,
  ROUND(SUM(fine_amount), 2) AS total_fines,
  ROUND(AVG(fine_amount), 2) AS avg_fine_amount
FROM checkout
GROUP BY material_type
ORDER BY total_fines DESC;
