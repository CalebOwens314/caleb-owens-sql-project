-- sql/duckdb/owens_library_kpi_checkouts.sql
-- ============================================================
-- PURPOSE
-- ============================================================
-- Calculate a Key Performance Indicator (KPI) for the library domain using DuckDB SQL.
--
-- KPI DRIVES THE WORK:
-- In analytics, we do not start with "write a query."
-- We start with a KPI that supports an actionable decision.
--
-- ACTIONABLE OUTCOME (EXAMPLE):
-- We want to identify which libraries are generating the most checkouts so we can:
-- - allocate staffing during high-performing periods,
-- - increase inventory for top categories,
-- - investigate why low-performing libraries are underperforming,
-- - target promotions where they will have the biggest impact.
--
-- In this example, our KPI is library checkout volume (total number of checkouts) by library.
--
-- ANALYST RESPONSIBILITY:
-- Analysts are responsible for determining HOW to get the information
-- that informs the KPI and supports action.
-- That means:
-- - identifying the needed tables,
-- - joining them correctly,
-- - selecting the right measures,
-- - aggregating at the correct level (library),
-- - and presenting results in a way that supports decision-making.
--
-- ASSUMPTION:
-- We always run all commands from the project root directory.
--
-- EXPECTED PROJECT PATHS (relative to repo root):
--   SQL:  sql/duckdb/owens_library_kpi_checkouts.sql
--   DB:   artifacts/duckdb/library.duckdb
--
--
-- ============================================================
-- TOPIC DOMAINS + 1:M RELATIONSHIPS
-- ============================================================
-- OUR DOMAIN: LIBRARY
-- Two tables in a 1-to-many relationship (1:M):
-- - branch (1): independent/parent table
-- - checkout  (M): dependent/child table
--
-- HOW THIS RELATES TO OUR KPI:
-- - The branch table tells us "which library" (branch_id, branch_name, location).
-- - The checkout table contains the measurable activity (checkout_id, checkout_date, etc.).
-- - To compute checkout volume by library, we must:
--   1) connect each checkout to its library (JOIN on branch_id),
--   2) aggregate checkout counts at the library level (GROUP BY branch).
--
--
-- ============================================================
-- KPI DEFINITION
-- ============================================================
-- KPI NAME: Total Checkout Volume by Library
--
-- KPI QUESTION:
-- "How many checkouts did each library generate?"
--
-- MEASURE:
-- - checkout volume = COUNT(checkout.checkout_id)
--
-- GRAIN (LEVEL OF DETAIL):
-- - one row per library
--
-- OUTPUT (WHAT DECISION-MAKERS NEED):
-- - library identifier and name
-- - total checkout volume
-- - optionally: number of checkouts and average checkout amount
--
--
-- ============================================================
-- EXECUTION: GET THE INFORMATION THAT INFORMS THE KPI
-- ============================================================
-- Strategy:
-- - JOIN branch (1) to checkout (M)
-- - GROUP BY branch
-- - COUNT checkout IDs to compute checkout volume
-- - ORDER results so we can quickly see top libraries
--
SELECT
  b.branch_id,
  b.branch_name,
  b.city,
  b.system_name,
  COUNT(c.checkout_id) AS checkout_count,
  ROUND(SUM(c.fine_amount), 2) AS total_fines,
  ROUND(AVG(c.fine_amount), 2) AS avg_fine_amount
FROM branch AS b
JOIN checkout AS c
  ON c.branch_id = b.branch_id
GROUP BY
  b.branch_id,
  b.branch_name,
  b.city,
  b.system_name
ORDER BY total_fines DESC;
