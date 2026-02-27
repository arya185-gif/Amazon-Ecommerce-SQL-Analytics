Project Title: Amazon-Style E-Commerce Revenue & Operational Analytics (SQL)

Project Overview :
Analyzed 100,000+ e-commerce transactions across 6 relational tables to generate revenue, seller performance, customer insights, and operational defect metrics.

Tools Used :
MySQL
SQL (Joins, Aggregations, Subqueries)
Data Modeling
KPI Analysis

Key Insights Generated :
Total Revenue & Monthly Growth Trend
Average Order Value (AOV)
Seller Revenue Concentration (Top 20%)
Customer Lifetime Value
Delivery SLA Compliance
Freight Cost % of Revenue
State-wise Revenue Distribution

Dataset:
Brazilian Olist E-Commerce Dataset (Kaggle)

Sample Query : (SQL)
SELECT 
customer_id,
ROUND(SUM(price + freight_value),2) AS lifetime_value
FROM master_orders
GROUP BY customer_id
ORDER BY lifetime_value DESC
LIMIT 10;
