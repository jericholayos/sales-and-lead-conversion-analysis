SET
	SEARCH_PATH TO PUBLIC;

-- Q11
SELECT
	channel,
	SUM(mc.budget) AS total_budget,
	COUNT(DISTINCT ct.touch_id) AS total_touchpoints,
	COUNT(*) FILTER(WHERE action = 'Signup') AS total_signups,
	ROUND(
	SUM(mc.budget) / NULLIF(COUNT(CASE WHEN action = 'Signup' THEN 1 ELSE 0 END), 0)
	, 2)AS cost_per_signup
FROM ecom_marketing_campaigns mc
INNER JOIN ecom_campaign_touchpoints ct
	ON mc.campaign_id = ct.campaign_id
GROUP BY 1
ORDER BY 5 ASC;

-- Q12
SELECT
	action,
	COUNT(*) AS total_touchpoints,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER() * 100, 2) AS pct_of_total
FROM ecom_campaign_touchpoints
GROUP BY 1
ORDER BY
	CASE action
		WHEN 'Open' THEN 1
		WHEN 'Click' THEN 2
		WHEN 'Signup' THEN 3
		WHEN 'Ignore' THEN 4
	END;



-- Q13
WITH CTE AS (
SELECT
	campaign_name,
	channel,
	mc.budget AS budget,
	COUNT(ct.touch_id) AS total_touchpoints,
	COUNT(*) FILTER(WHERE action = 'Signup') AS signups
FROM ecom_marketing_campaigns mc
LEFT JOIN ecom_campaign_touchpoints ct
	ON mc.campaign_id = ct.campaign_id
GROUP BY 1, 2, 3
)
SELECT
	campaign_name,
	channel,
	budget,
	total_touchpoints,
	signups,
	ROUND(signups::NUMERIC / NULLIF(total_touchpoints, 0) * 100, 2) AS signup_rate
FROM cte
ORDER BY 6 DESC
LIMIT 5;


-- Q14
SELECT
	device,
	action,
	COUNT(*) AS total_touchpoints,
	ROUND(COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER() * 100, 2) AS pct_of_total
FROM ecom_campaign_touchpoints
GROUP BY 1, 2
ORDER BY 1, 
	CASE action
		WHEN 'Open' THEN 1
		WHEN 'Click' THEN 2
		WHEN 'Signup' THEN 3
		WHEN 'Ignore' THEN 4
	END;



-- Q15
WITH CTE AS (
SELECT
	o.customer_id,
	COUNT(o.order_id) AS order_count,
	SUM(o.order_total) AS total_spent
FROM ecom_orders o
WHERE o.order_status = 'Delivered'
GROUP BY 1
),
CTE2 AS (
SELECT
	*,
	CASE
		WHEN order_count = 1 THEN 'One-Time'
		WHEN order_count <= 4 THEN 'Repeat'
		WHEN order_count >= 5 THEN 'Loyal' 
	END AS frequency_segment
FROM cte
)
SELECT
	frequency_segment,
	COUNT(*) AS customer_count,
	ROUND(SUM(total_spent), 2) AS total_revenue,
	ROUND(AVG(total_spent), 2) AS avg_revenue_per_customer
FROM cte2
GROUP BY 1
ORDER BY 3 DESC;


-- Q16
WITH monthly AS (
SELECT
	TO_CHAR(DATE_TRUNC('Month', o.order_date), 'YYYY-MM') AS months,
	SUM(oi.line_revenue) AS monthly_revenue
FROM ecom_orders o 
INNER JOIN ecom_order_items oi
	ON o.order_id = oi.order_id
GROUP BY 1
)
SELECT
	*,
	SUM(monthly_revenue) OVER(ORDER BY months ROWS UNBOUNDED PRECEDING) AS running_total
FROM monthly
ORDER BY 1 ASC;


-- Q17
WITH CTE AS(
SELECT
	sr.name AS rep_name,
	o.region,
	SUM(oi.line_revenue) AS total_revenue
FROM ecom_sales_reps sr
INNER JOIN ecom_orders o
	ON sr.sales_rep_id = o.sales_rep_id
INNER JOIN ecom_order_items oi 
	ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY sr.name, o.region
)
SELECT
	*,
	RANK() OVER(PARTITION BY region ORDER BY total_revenue DESC) AS region_rank
FROM cte
ORDER BY region, region_rank;
	





















