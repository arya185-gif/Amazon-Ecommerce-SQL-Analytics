#PHASE 7 – DELIVERY & OPERATIONS ANALYSIS
#13.PHASE 7 – DELIVERY & OPERATIONS ANALYSIS
SELECT 
ROUND(AVG(DATEDIFF(order_delivered_customer_date, 
                   order_purchase_timestamp)),2) 
AS avg_delivery_days
FROM olist_orders_dataset
WHERE order_status = 'delivered';

#14. Late Delivery Rate
SELECT 
ROUND(
SUM(CASE 
    WHEN order_delivered_customer_date > order_estimated_delivery_date 
    THEN 1 ELSE 0 END)
/ COUNT(*) * 100
,2) AS late_delivery_percent
FROM olist_orders_dataset
WHERE order_status = 'delivered'; 

#15. Freight Cost as % of Revenue
SELECT 
ROUND(
SUM(freight_value) / SUM(price + freight_value) * 100
,2) AS freight_percent
FROM master_orders;

#PHASE 8 – CUSTOMER SEGMENTATION
#16. PHASE 8 – CUSTOMER SEGMENTATION
SELECT 
customer_id,
ROUND(SUM(price + freight_value),2) AS lifetime_value
FROM master_orders
GROUP BY customer_id
ORDER BY lifetime_value DESC
LIMIT 10;

#17. Revenue by State
SELECT 
customer_state,
ROUND(SUM(price + freight_value),2) AS revenue
FROM master_orders
GROUP BY customer_state
ORDER BY revenue DESC;

#18. Orders per Customer Distribution
SELECT 
COUNT(DISTINCT order_id) AS orders,
COUNT(customer_id) AS number_of_customers
FROM master_orders
GROUP BY customer_id;

#PHASE 9 – PRODUCT INTELLIGENCE
#19.High Revenue, Low Volume Products
SELECT 
product_id,
COUNT(order_id) AS order_count,
ROUND(SUM(price),2) AS revenue
FROM master_orders
GROUP BY product_id
HAVING order_count < 5
ORDER BY revenue DESC
LIMIT 10;

#20.Average Product Price by Category
SELECT 
product_category_name,
ROUND(AVG(price),2) AS avg_price
FROM master_orders
GROUP BY product_category_name
ORDER BY avg_price DESC;

#PHASE 10 – TIME SERIES INSIGHTS
#21. Monthly Order Growth %
SELECT 
month,
monthly_orders,
ROUND(
(monthly_orders - LAG(monthly_orders) 
 OVER (ORDER BY month)) /
LAG(monthly_orders) OVER (ORDER BY month) * 100
,2) AS growth_percent
FROM (
    SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT order_id) AS monthly_orders
    FROM master_orders
    GROUP BY month
) t;