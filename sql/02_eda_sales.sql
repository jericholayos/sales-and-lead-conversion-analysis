SET
	SEARCH_PATH TO PUBLIC;

SELECT
	*
FROM
	ECOM_ORDERS
LIMIT
	10;

-- Total Revenue: 54,091,275
-- Total Orders: 9064
-- AOV: 5967.70
SELECT
	SUM(ORDER_TOTAL) AS TOTAL_REVENUE,
	COUNT(ORDER_ID) AS TOTAL_ORDERS,
	ROUND(SUM(ORDER_TOTAL) / COUNT(*), 2) AS AVG_ORDER_VALUE
FROM
	ECOM_ORDERS
WHERE
	ORDER_STATUS = 'Delivered';


-- Q2 monthly revenue trend
-- 2023-04 has the highest total revenue at 1.6M (2.9%)
-- 2025-01 has the lowest total revenue at 1M (1.8%)
WITH
	CTE AS (
		SELECT
			DATE_TRUNC('month', ORDER_DATE)::DATE AS MONTHS,
			SUM(OI.LINE_REVENUE) AS TOTAL_REVENUE,
			COUNT(DISTINCT O.ORDER_ID) AS ORDER_COUNT
		FROM
			ECOM_ORDERS O
			INNER JOIN ECOM_ORDER_ITEMS OI ON OI.ORDER_ID = O.ORDER_ID
		WHERE
			ORDER_STATUS = 'Delivered'
		GROUP BY
			1
	)
SELECT
	*,
	ROUND(
		TOTAL_REVENUE * 100 / SUM(TOTAL_REVENUE) OVER (),
		2
	) AS PCT
FROM
	CTE
ORDER BY
	2 DESC;


-- Q3 revenue by country and region
-- usa is the most dominant with a total revenue of 14.4M
-- 2nd is philippines at 11.5M
-- lowest is canada at 5M
SELECT
	COUNTRY,
	REGION,
	SUM(OI.LINE_REVENUE) AS TOTAL_REVENUE,
	ROUND(
		(SUM(OI.LINE_REVENUE) * 100) / SUM(SUM(OI.LINE_REVENUE)) OVER (),
		2
	) AS PCT_OF_TOTAL
FROM
	ECOM_ORDERS O
	INNER JOIN ECOM_ORDER_ITEMS OI ON OI.ORDER_ID = O.ORDER_ID
WHERE
	ORDER_STATUS = 'Delivered'
GROUP BY
	1,
	2
ORDER BY
	4 DESC;


-- Q4 TOP 10 sales rep by revenue
SELECT
	RANK() OVER (
		ORDER BY
			SUM(OI.LINE_REVENUE) DESC
	) AS RANK,
	SR.NAME AS REP_NAME,
	O.REGION,
	SUM(OI.LINE_REVENUE) AS TOTAL_REVENUE,
	COUNT(DISTINCT O.ORDER_ID) AS ORDER_COUNT,
	ROUND(
		COUNT(
			DISTINCT CASE
				WHEN O.ORDER_STATUS = 'Delivered' THEN O.ORDER_ID
			END
		)::NUMERIC / COUNT(DISTINCT O.ORDER_ID) * 100,
		2
	) AS WIN_RATE
FROM
	ECOM_ORDERS O
	INNER JOIN ECOM_ORDER_ITEMS OI ON OI.ORDER_ID = O.ORDER_ID
	INNER JOIN ECOM_SALES_REPS SR ON SR.SALES_REP_ID = O.SALES_REP_ID
GROUP BY
	2,
	3
LIMIT
	10;
	
--Q5 
-- most sold category are furnitures
-- and the most sold sub category is 'Shelving' at 4.9M and 1508 units sold
SELECT
	CATEGORY,
	SUB_CATEGORY,
	SUM(OI.LINE_REVENUE) AS TOTAL_REVENUE,
	SUM(OI.QUANTITY) AS UNITS_SOLD,
	ROUND(AVG(OI.UNIT_PRICE), 2) AS AVG_UNIT_PRICE
FROM
	ECOM_ORDER_ITEMS OI
	INNER JOIN ECOM_ORDERS O ON OI.ORDER_ID = O.ORDER_ID
WHERE
	ORDER_STATUS = 'Delivered'
GROUP BY
	1,
	2
ORDER BY
	3 DESC;


-- Q6

-- delivered has 54M total revenue
-- shipped has 10M
-- processing has 8M
-- cancelled has 6.5M
-- returned has 4.3M
SELECT
	COUNT(*),
	ORDER_STATUS,
	ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) AS total_pct
FROM
	ECOM_ORDERS
GROUP BY
	2
ORDER BY
	1 DESC;













	




	