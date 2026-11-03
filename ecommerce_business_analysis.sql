Drop Database If exists ecommerce_analytics;
Create DataBASE ecommerce_analytics;

CREATE TABLE customers (
   customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);
Select * From Customers;

Drop Table If Exists geolocation;
CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat NUMERIC(10,7),
    geolocation_lng NUMERIC(10,7),
   geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);
Select * From geolocation;

CREATE TABLE order_items (
    order_id VARCHAR(50),
  order_item_id INTEGER,
   product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),

    PRIMARY KEY (order_id, order_item_id)
);
Select * From order_items;

SELECT * FROM order_items
WHERE order_id IS NULL OR order_item_id IS NULL
   OR product_id IS NULL
   OR seller_id IS NULL
   OR shipping_limit_date IS NULL
   OR price IS NULL
   OR freight_value IS NULL;

 SELECT order_id, COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id
HAVING COUNT(*) > 1;


CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(30),
    payment_installments INTEGER,
    payment_value NUMERIC(10,2),

    PRIMARY KEY (order_id, payment_sequential)
);
Select * From order_payments;
SELECT * FROM order_payments
WHERE order_id IS NULL
OR payment_sequential IS NULL
 OR payment_type IS NULL
   OR payment_installments IS NULL
   OR payment_value IS NULL;

CREATE TABLE order_reviews (
   review_id VARCHAR(50),
   order_id VARCHAR(50),
  review_score SMALLINT,
  review_comment_title TEXT,
  review_comment_message TEXT,
  review_creation_date TIMESTAMP,
   review_answer_timestamp TIMESTAMP
);
SELECT * FROM order_reviews
WHERE review_id IS NULL
   OR order_id IS NULL
   OR review_score IS NULL
   OR review_creation_date IS NULL
   OR review_answer_timestamp IS NULL;
SELECT * FROM order_reviews;

SELECT * FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5;

CREATE TABLE orders (
 order_id VARCHAR(50) PRIMARY KEY,
 customer_id VARCHAR(50),
 order_status VARCHAR(30),
  order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMP
);
SELECT * FROM orders;

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);
SELECT * FROM products;

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);
SELECT * FROM sellers;

select * From Sellers
where seller_id is null;

Select seller_id, count(*) As dublicate_Seller_id
From sellers
group by seller_id 
having count(*)>1;

 CREATE TABLE category_translation (
  product_category_name VARCHAR(100) PRIMARY KEY,
  product_category_name_english VARCHAR(100)
);
select * From category_translation;

SELECT product_category_name_english
FROM category_translation
ORDER BY product_category_name_english;

-- check The table Available --
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation
ORDER BY table_name;

-- 01 Order Volume By Status
SELECT order_status,COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 02 Monthly Order Volume
SELECT DATE_TRUNC('month', order_purchase_timestamp)::DATE AS order_month,
COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_TRUNC('month', order_purchase_timestamp)::DATE
ORDER BY order_month;

-- 03. Top 10 Product Categories by Sales
SELECT p.product_category_name,SUM(oi.price) AS total_sales
FROM order_items AS oi
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_sales DESC
LIMIT 10;

-- 04. Sales Distribution by Payment Method
SELECT payment_type, COUNT(*) AS payment_records,
ROUND(SUM(payment_value), 2) AS total_payment
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment DESC;

-- 05. Seller-wise Sales Performance
SELECT s.seller_id, s.seller_state, 
ROUND(SUM(oi.price), 2) AS total_sales,
COUNT(*) AS total_items_sold
FROM sellers AS s
JOIN order_items AS oi
ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_state
ORDER BY total_sales DESC
LIMIT 10;

--06 – Average Delivery Time --
SELECT ROUND(AVG(EXTRACT(EPOCH FROM (
 order_delivered_customer_date
 - order_purchase_timestamp)) / 86400), 2) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;
 
-- 07 – Late Delivery Analysis --

SELECT CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date
        THEN 'Late Delivery'
        ELSE 'On-Time Delivery'
       END AS delivery_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY
CASE
 WHEN order_delivered_customer_date > order_estimated_delivery_date
   THEN 'Late Delivery'
   ELSE 'On-Time Delivery'
 END
 ORDER BY total_orders DESC;

 -- 08 – Customer Review Score Analysis-- 
SELECT  review_score, COUNT(*) AS total_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;

Select * From Orders;


-- Delivery Performance vs Customer Reviews --
SELECT CASE
     WHEN o.order_delivered_customer_date >
          o.order_estimated_delivery_date
      THEN 'Late Delivery'
       ELSE 'On-Time Delivery'
   END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
   COUNT(*) AS total_reviews
FROM orders AS o
JOIN order_reviews AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY
    CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN 'Late Delivery'
        ELSE 'On-Time Delivery' END
ORDER BY avg_review_score DESC;


-- 10 – Order Cancellation Analysis --
SELECT order_status, COUNT(*) AS total_orders,
 ROUND(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2
    ) AS order_percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 11. Repeat Customer Analysis --
SELECT c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;



-- 12 – Repeat Customer Rate --
WITH customer_orders AS (
SELECT c.customer_unique_id, COUNT(o.order_id) AS total_orders
FROM orders AS o
JOIN customers AS c
 ON o.customer_id = c.customer_id
 GROUP BY c.customer_unique_id)
SELECT COUNT(*) AS total_customers,
COUNT(*) FILTER (WHERE total_orders > 1) AS repeat_customers,
ROUND(COUNT(*) FILTER (WHERE total_orders > 1) * 100.0/ COUNT(*),
2) AS repeat_customer_rate
FROM customer_orders;
WITH customer_orders AS (
  SELECT c.customer_unique_id,
 COUNT(o.order_id) AS total_orders
 FROM orders AS o
 JOIN customers AS c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id)
SELECT
COUNT(*) AS total_repeat_customers,
SUM(total_orders) AS orders_from_repeat_customers,
ROUND(AVG(total_orders), 2) AS avg_orders_per_repeat_customer
FROM customer_orders
WHERE total_orders > 1;


-- 13 – Top 10 States by Customer Orders --
SELECT c.customer_state, COUNT(o.order_id) AS total_orders
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_state
ORDER BY
    total_orders DESC
LIMIT 10;


-- 14 Top 10 States by Revenue -- 
SELECT c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_state
ORDER BY
    total_revenue DESC
LIMIT 10;


 -- 14 Average Order Value (AOV) by State --
SELECT c.customer_state,COUNT(DISTINCT o.order_id) AS total_orders, ROUND(
SUM(oi.price) / COUNT(DISTINCT o.order_id),2  ) AS avg_order_value
FROM orders AS o
JOIN customers AS c
  ON o.customer_id = c.customer_id
JOIN order_items AS oi
 ON o.order_id = oi.order_id
GROUP BY
  c.customer_state
ORDER BY  avg_order_value DESC
LIMIT 10;

-- 15.Top 10 Customers by Total Spending --
SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(oi.price), 2) AS total_spending
FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY
c.customer_unique_id
ORDER BY total_spending DESC 
LIMIT 10;


-- 16 – Monthly Revenue Trend --
SELECT DATE_TRUNC('month', o.order_purchase_timestamp)::DATE AS order_month,
ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY
DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY
order_month;

--17. Month-over-Month Revenue Growth -- 
WITH monthly_sales AS ( SELECT DATE_TRUNC('month', o.order_purchase_timestamp)::DATE AS order_month,
     SUM(oi.price) AS monthly_revenue
    FROM orders AS o
    JOIN order_items AS oi
    ON o.order_id = oi.order_id
    WHERE o.order_purchase_timestamp IS NOT NULL
    GROUP By DATE_TRUNC('month', o.order_purchase_timestamp)),
revenue_comparison AS (
    SELECT order_month, monthly_revenue,
        LAG(monthly_revenue) OVER ( ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_sales)
SELECT order_month, ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
	(monthly_revenue - previous_month_revenue)
        * 100.0 / NULLIF(previous_month_revenue, 0),2
    ) AS revenue_growth_percentage
FROM revenue_comparison
ORDER BY order_month;

-- 18 – Customer Purchase Ranking  --
WITH customer_purchase AS (SELECT c.customer_unique_id,o.order_id,
 o.order_purchase_timestamp,
 ROW_NUMBER() OVER (
 PARTITION BY c.customer_unique_id
 ORDER BY o.order_purchase_timestamp ) AS purchase_number
 FROM orders AS o
 JOIN customers AS c
  ON o.customer_id = c.customer_id)
SELECT customer_unique_id, order_id,order_purchase_timestamp, purchase_number
FROM customer_purchase
WHERE purchase_number <= 3
ORDER BY customer_unique_id, purchase_number;

-- 19 Top 3 Products by Revenue in Each Category --
WITH product_sales AS ( SELECT p.product_category_name,oi.product_id,
 SUM(oi.price) AS total_revenue
FROM order_items AS oi
JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY
p.product_category_name,oi.product_id),
product_ranking AS (
SELECT product_category_name,product_id,total_revenue,
	DENSE_RANK() OVER (
            PARTITION BY product_category_name
            ORDER BY total_revenue DESC) AS product_rank
    FROM product_sales) 
SELECT product_category_name, product_id, ROUND(total_revenue, 2) AS total_revenue,
product_rank
FROM product_ranking
WHERE product_rank <= 3
ORDER BY product_category_name, product_rank;

-- 20 Seller Performance Ranking --
WITH seller_rank AS (
    SELECT s.seller_state,oi.seller_id,
        SUM(oi.price) AS revenue,
        DENSE_RANK() OVER (
		PARTITION BY s.seller_state
            ORDER BY SUM(oi.price) DESC) AS rnk
    FROM order_items oi
    JOIN sellers s ON oi.seller_id = s.seller_id
    GROUP BY s.seller_state, oi.seller_id
)
SELECT *
FROM seller_rank
WHERE rnk <= 3
ORDER BY seller_state, rnk;

-- 21 Seller Delivery & Customer Satisfaction Analysis --
SELECT oi.seller_id,COUNT(DISTINCT o.order_id) AS total_orders,
COUNT(DISTINCT o.order_id) FILTER (
 WHERE o.order_delivered_customer_date >
 o.order_estimated_delivery_date) AS late_orders,
ROUND(AVG(r.review_score), 2) AS avg_rating,
ROUND(COUNT(DISTINCT o.order_id) FILTER (
WHERE o.order_delivered_customer_date >
o.order_estimated_delivery_date) * 100.0 /
NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS late_delivery_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT o.order_id) >= 10
ORDER BY late_delivery_pct DESC;

-- Query 22 – Customer Retention Analysis --

WITH customer_orders AS (SELECT c.customer_unique_id,
COUNT(DISTINCT o.order_id) AS total_orders,
        MIN(o.order_purchase_timestamp) AS first_order,
        MAX(o.order_purchase_timestamp) AS last_order
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id)
SELECT
 COUNT(*) AS total_customers,
COUNT(*) FILTER (WHERE total_orders > 1) AS repeat_customers,
    COUNT(*) FILTER (WHERE total_orders = 1) AS one_time_customers,
    ROUND(
        COUNT(*) FILTER (WHERE total_orders > 1) * 100.0 /
        NULLIF(COUNT(*), 0), 2
    ) AS repeat_customer_pct,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer
FROM customer_orders;





