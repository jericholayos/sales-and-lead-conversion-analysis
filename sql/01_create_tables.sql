CREATE TABLE ecom_customers (
	customer_id 		INT PRIMARY KEY,
	full_name 			VARCHAR,
	email 				VARCHAR,
	phone 				VARCHAR,
	country 			VARCHAR,
	city 				VARCHAR,
	region 				VARCHAR,
	segment 			VARCHAR,
	acquisition_channel VARCHAR,
	signup_date 		DATE
);

CREATE TABLE ecom_sales_reps (
	sales_rep_id 		INT PRIMARY KEY,
	name 				VARCHAR,
	region 				VARCHAR,
	hire_date 			DATE
);

CREATE TABLE ecom_orders (
	order_id 			INT PRIMARY KEY,
	customer_id 		INT REFERENCES ecom_customers(customer_id),
	sales_rep_id 		INT REFERENCES ecom_sales_reps(sales_rep_id),
	order_date			DATE,
	ship_date			DATE,
	ship_mode 			VARCHAR,
	order_status 		VARCHAR,
	payment_method		VARCHAR,
	country				VARCHAR,
	city				VARCHAR,
	region				VARCHAR,
	order_total 		NUMERIC
);

CREATE TABLE ecom_order_items (
	item_id 			INT PRIMARY KEY,
	order_id			INT REFERENCES ecom_orders(order_id),
	product_id 			VARCHAR,
	product_name 		VARCHAR,
	category			VARCHAR,
	sub_category		VARCHAR,
	quantity			INT,
	unit_price			NUMERIC,
	discount_pct 		NUMERIC,
	discount_amt 		NUMERIC,
	line_revenue 		NUMERIC
);

CREATE TABLE ecom_leads(
	lead_id 			INT PRIMARY KEY,
	customer_id			INT,
	created_date 		DATE,
	source 				VARCHAR,
	status 				VARCHAR,
	follow_up_date 		DATE
);

CREATE TABLE ecom_marketing_campaigns(
	campaign_id INT PRIMARY KEY,
	campagin_name VARCHAR,
	channel VARCHAR,
	start_date DATE,
	end_date DATE,
	budget NUMERIC,
	target_segment VARCHAR
);


CREATE TABLE ecom_campaign_touchpoints(
	touch_id INT PRIMARY KEY,
	customer_id INT REFERENCES ecom_customers(customer_id),
	campaign_id INT REFERENCES ecom_marketing_campaigns(campaign_id),
	intereaction_date DATE,
	action VARCHAR,
	device VARCHAR
);

SELECT 'customers'    AS tbl, COUNT(*) FROM ecom_customers 
UNION ALL 
SELECT 'orders',              COUNT(*) FROM ecom_orders 
UNION ALL 
SELECT 'order_items',         COUNT(*) FROM ecom_order_items 
UNION ALL 
SELECT 'leads',               COUNT(*) FROM ecom_leads 
UNION ALL 
SELECT 'sales_reps',          COUNT(*) FROM ecom_sales_reps 
UNION ALL 
SELECT 'campaigns',           COUNT(*) FROM ecom_marketing_campaigns 
UNION ALL 
SELECT 'touchpoints',         COUNT(*) FROM ecom_campaign_touchpoints;

SELECT
	COUNT(*) AS total_leads,
	COUNT(customer_id) AS converted,
	COUNT(*) - COUNT(customer_id) AS not_converted,
	ROUND(COUNT(customer_id)::numeric / COUNT(*) * 100, 1) AS conversion_pct
FROM ecom_leads;




































