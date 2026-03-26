
CREATE TEMP TABLE tmp_sales AS
SELECT *
FROM (
    VALUES
        
        (1,  'A', DATE '2024-01-01', 100, 'online'),
        (2,  'A', DATE '2024-01-02', 120, 'store'),
        (3,  'A', DATE '2024-01-03', 90,  'online'),
        (4,  'A', DATE '2024-01-04', 130, 'store'),

        
        (5,  'B', DATE '2024-01-01', 180, 'store'),
        (6,  'B', DATE '2024-01-02', 200, 'online'),
        (7,  'B', DATE '2024-01-03', 220, 'online'),
        (8,  'B', DATE '2024-01-04', 200, 'store'),

        
        (9,  'C', DATE '2024-01-01', 150, 'online'),
        (10, 'C', DATE '2024-01-02', 150, 'online'),
        (11, 'C', DATE '2024-01-03', 170, 'online'),

        
        (12, 'D', DATE '2024-01-01', 90,  'store'),
        (13, 'D', DATE '2024-01-02', 110, 'store'),

        
        (14, 'E', DATE '2024-01-01', 140, 'store'),
        (15, 'E', DATE '2024-01-02', 160, 'online'),
        (16, 'E', DATE '2024-01-03', 155, 'store')
) AS t(
    sale_id,
    customer_id,
    sale_date,
    amount,
    channel
);

		-- Window Function Layer 1: Simple Aggregate Window Functions
	-- How does this row relate to an aggregate of its group/partition?


-- Example 1: Average Amount per Customer

SELECT
	sale_id,
	customer_id,
	sale_date,
	amount,
	channel,
	AVG(amount) OVER (PARTITION BY customer_id) AS avg_customer_amount
FROM tmp_sales;

-- Example 2: Total Spend per Customer


SELECT
	sale_id,
	customer_id,
	amount,
	SUM(amount) OVER (PARTITION BY customer_id) AS total_customer_spend
FROM tmp_sales;

-- Example 3: Number of Transactions per Customer

SELECT
	sale_id,
	customer_id,
	amount,
	COUNT(*) OVER (PARTITION BY customer_id) AS transaction_id
FROM tmp_sales;

-- Example 4: Minimum and Maximum Amount per Customer


SELECT
	sale_id,
	customer_id,
	amount,
	MAX (amount) OVER (PARTITION BY customer_id) 
	AS max_amount,
	MIN (amount) OVER (PARTITION BY customer_id) 
	AS min_amount
FROM tmp_sales;

			-- Window Function Layer 2: Statistical Window Functions
		-- Where does this row stand within the distribution of its group?


-- Example 1: Median Amount per Customer

SELECT 
	customer_id,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY amount)
	AS median_amount
FROM tmp_sales
GROUP BY customer_id;


-- Example 2: Percent Rank of Each Transaction

SELECT
	sale_id,
	customer_id,
	amount,
	PERCENT_RANK() OVER (PARTITION BY customer_id ORDER BY amount)
	AS percent_rank
FROM tmp_sales;

-- Example 3: Cumulative Distribution

SELECT
	sale_id,
	customer_id,
	amount,
	CUME_DIST() OVER (PARTITION BY customer_id ORDER BY amount)
	AS cumulative_distribution
FROM tmp_sales;


-- Example 4: Quartile Assignment

SELECT 
	sale_id,
	customer_id,
	amount,
	NTILE(4) OVER (PARTITION BY customer_id ORDER BY amount)
	AS quartile
FROM tmp_sales;

				-- When to Use Statistical Window Functions
				
				-- Understanding customer behavior distributions
				-- Identifying top/bottom performers
				-- Creating quantile-based segments
				-- Normalizing values for comparison


			-- Window Function Layer 3: Value-from-Another-Row Functions
		-- How does this row relate to previous or next rows in sequence?
		
-- Example 1: Previous Transaction Amount (LAG)

SELECT
	sale_id,
	customer_id,
	sale_date,
	amount,
	LAG(amount) OVER (PARTITION BY customer_id ORDER BY sale_date)
	AS previous_amount
FROM tmp_sales;

-- Example 2: Next Transaction Amount (LEAD)

SELECT
	customer_id,
	sale_id,
	sale_date,
	amount,
	LEAD (amount) OVER (PARTITION BY customer_id ORDER BY sale_date)
	AS next_transaction_amount
FROM tmp_sales;

-- Example 3: Change Since Previous Transaction

SELECT
	customer_id,
	sale_id,
	sale_date,
	amount,
	-LAG(amount) OVER (PARTITION BY customer_id ORDER BY sale_date)
	AS amount_change
FROM tmp_sales;


-- Example 4: First Transaction Amount per Customer

SELECT 
	customer_id
	sale_id,
	sale_date,
	amount,
	FIRST_VALUE(amount) OVER (PARTITION BY customer_id ORDER BY sale_date)
	AS first_transaction_amount
FROM tmp_sales;


-- Example 5: Last Transaction Amount per Customer

SELECT
	customer_id,
	sale_id,
	sale_date,
	amount,
	LAST_VALUE (amount) OVER(PARTITION BY customer_id ORDER BY sale_date
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
	AS last_transaction_amount
FROM tmp_sales;

				
							-- Important
-- Ordering is mandatory
-- These functions are directional
-- They enable:
-- Trend analysis
-- Change detection
-- Time-series feature engineering

						-- Window Function Layer 4: Ranking Functions

			-- How does this row rank relative to other rows in its group?

-- Example 1: Sequential Ordering (ROW_NUMBER)

SELECT
    sale_id,
    customer_id,
    sale_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date)
	AS row_number
FROM tmp_sales;

-- Example 2: Ranking by Amount with Gaps (RANK)

SELECT
    sale_id,
    customer_id,
    sale_date,
	amount,
    RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC)
	AS rank_amount
FROM tmp_sales;

-- Example 3: Dense Ranking by Amount (DENSE_RANK)

SELECT
    sale_id,
    customer_id,
    amount,
    DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC) 
	AS dense_rank_amount
FROM tmp_sales;





































