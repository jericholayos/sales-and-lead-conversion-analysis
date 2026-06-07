set search_path to public;

-- Q7
SELECT 
	source,
	COUNT(*) AS total_leads,
	COUNT(customer_id) AS converted,
	ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS conversion_rate
FROM ecom_leads
GROUP BY 1
ORDER BY 4 DESC;


-- Q8
SELECT
	status,
	COUNT(*) AS lead_count,
	ROUND(
		COUNT(*) / SUM(COUNT(*)) OVER() * 100.0,
	2) AS conversion_rate
FROM ecom_leads
GROUP BY 1
ORDER BY 
	CASE status
		WHEN 'New' THEN 1
		WHEN 'Contaced' THEN 2
		WHEN 'Qualified' THEN 3
		WHEN 'Lost' THEN 4
		WHEN 'Contaced' THEN 5
	END;

-- Q9
SELECT
	DATE_TRUNC('Month', created_date)::DATE AS months,
	COUNT(*) AS total_leads,
	COUNT(customer_id) AS converted,
	ROUND(COUNT(customer_id)::NUMERIC / COUNT(*) * 100, 2) AS conversion_rate
FROM ecom_leads
GROUP BY 1
ORDER BY 1;

-- Q10
SELECT 
	acquisition_channel,
	segment,
	COUNT(customer_id) AS customer_count,
	ROUND(COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER() * 100, 2) AS pct_of_total
FROM ecom_customers
GROUP BY 1, 2
ORDER BY 3 DESC;


 	
























