#PHASE1 – REVENUE ANALYSIS (Amazon Core KPI)
#1. Total Revenue 
SELECT ROUND(SUM(price+ freight_value),2) AS total_revenue
FROM master_orders;

#2. Total Orders
SELECT COUNT(distinct order_id ) as total_orders 
FROM master_orders;

#3. Average Order Value (AOV)
SELECT 
ROUND(SUM(price + freight_value) / COUNT(DISTINCT order_id),2) AS avg_order_value
FROM master_orders;

#4. Monthly Revenue Trend
SELECT 
DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
ROUND(SUM(price + freight_value),2) AS monthly_revenue
FROM master_orders
GROUP BY month
ORDER BY month;

#PHASE 2 – OPERATIONAL METRICS

#5. Order Status Breakdown
select order_status,
count(distinct order_id) as orders
from master_orders
Group by order_status;

#6. Cancellation rate 
SELECT 
ROUND(
SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END)
/ COUNT(DISTINCT order_id) * 100,2
) AS cancellation_rate_percent
FROM master_orders;

#PHASE 3 – CUSTOMER ANALYTICS

#7. Repeat Customers
SELECT 
COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM master_orders
    GROUP BY customer_id
    HAVING COUNT(DISTINCT order_id) > 1
) t;

#8. Top 10 Cities by Revenue
SELECT 
customer_city,
ROUND(SUM(price + freight_value),2) AS revenue
FROM master_orders
GROUP BY customer_city
ORDER BY revenue DESC
LIMIT 10;

#PHASE 4 – SELLER PERFORMANCE
#9. Top 10 Sellers by Revenue
SELECT 
seller_id,
ROUND(SUM(price + freight_value),2) AS seller_revenue
FROM master_orders
GROUP BY seller_id
ORDER BY seller_revenue DESC
LIMIT 10;

#PHASE 5 – PRODUCT ANALYSIS
#10. Revenue by Category
SELECT 
product_category_name,
ROUND(SUM(price + freight_value),2) AS revenue
FROM master_orders
GROUP BY product_category_name
ORDER BY revenue DESC;

#PHASE 6 – ADVANCED REVENUE INSIGHTS

#11. Revenue Contribution % by Category
SELECT 
product_category_name,
ROUND(SUM(price + freight_value),2) AS revenue,
ROUND(
SUM(price + freight_value) / 
(SELECT SUM(price + freight_value) FROM master_orders) * 100
,2) AS contribution_percent
FROM master_orders
GROUP BY product_category_name
ORDER BY revenue DESC;

#12. Top 10% Sellers Contribution (Revenue Concentration)
WITH seller_revenue AS (
    SELECT seller_id,
           SUM(price + freight_value) AS revenue
    FROM master_orders
    GROUP BY seller_id
)
SELECT 
ROUND(SUM(revenue),2) AS top_seller_revenue
FROM (
    SELECT revenue
    FROM seller_revenue
    ORDER BY revenue DESC
    LIMIT (
        SELECT COUNT(*) * 0.2 FROM seller_revenue
    )
) t;



