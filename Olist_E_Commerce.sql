-- ================================================================
--        E-COMMERCE SALES ANALYSIS | SQL SERVER
-- ================================================================
--  Author   : Harsh Vaibhav
--  Date     : January 2026
--  Dataset  : Brazilian Olist E-Commerce (Kaggle)
--  Tool     : SQL Server Management Studio (SSMS)
--  Records  : 100,000+ Transactional Records
-- ================================================================
--  OBJECTIVE:
--  Analyze sales performance, customer purchasing behavior,
--  and product profitability using advanced SQL techniques
--  including CTEs, Window Functions, JOINs & Aggregations.
-- ================================================================
--  TABLE OF CONTENTS:
--  STEP 1  → Total Revenue, Orders & Customers
--  STEP 2  → Top 5 Revenue Generating Products
--  STEP 3  → Profit Margin % by Category
--  STEP 4  → Average Order Value (AOV)
--  STEP 5  → Customer Retention Analysis
--  STEP 6  → Monthly Revenue Trend
--  STEP 7  → Revenue by Payment Type
--  STEP 8  → Top 10 Sellers by Revenue
--  STEP 9  → Order Delivery Performance
--  STEP 10 → Key Business Metrics Summary
-- ================================================================

USE OlistEcommerce;


-- ================================================================
-- STEP 1: TOTAL REVENUE, ORDERS & CUSTOMERS
-- ----------------------------------------------------------------
-- Business Question:
--   What is the overall business performance snapshot?
-- Metrics:
--   → Total Revenue   : Sum of all payments received
--   → Total Orders    : Count of unique orders placed
--   → Total Customers : Count of unique registered customers
-- Technique: Aggregation + Subquery
-- ================================================================

SELECT 
    ROUND(SUM(payment_value), 2)         AS Total_Revenue,
    COUNT(DISTINCT order_id)             AS Total_Orders,
    (SELECT COUNT(DISTINCT customer_id) 
     FROM olist_customers_dataset)       AS Total_Customers
FROM olist_order_payments_dataset;


-- ================================================================
-- STEP 2: TOP 5 REVENUE GENERATING PRODUCTS
-- ----------------------------------------------------------------
-- Business Question:
--   Which product categories drive the most revenue?
-- Metrics:
--   → Revenue Rank       : Category ranked by total revenue
--   → Total Revenue      : Sum of prices per category
--   → Total Orders       : Number of orders per category
--   → Revenue Percentage : Category share of total revenue
-- Technique: CTE + JOIN + RANK() Window Function
-- ================================================================

WITH product_revenue AS (
    -- Calculate total revenue and order count per category
    SELECT 
        p.product_category_name             AS Product_Category,
        ROUND(SUM(oi.price), 2)             AS Total_Revenue,
        COUNT(DISTINCT oi.order_id)         AS Total_Orders
    FROM olist_order_items_dataset oi
    -- Join order items with products to get category names
    JOIN olist_products_dataset p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
),
ranked_products AS (
    -- Rank each category by revenue using Window Function
    SELECT *,
        RANK() OVER (ORDER BY Total_Revenue DESC) AS Revenue_Rank
    FROM product_revenue
)
-- Return only Top 5 with their % contribution to total revenue
SELECT TOP 5
    Revenue_Rank,
    Product_Category,
    Total_Revenue,
    Total_Orders,
    ROUND(Total_Revenue * 100.0 / SUM(Total_Revenue) OVER(), 2) AS Revenue_Percentage
FROM ranked_products
ORDER BY Revenue_Rank;


-- ================================================================
-- STEP 3: PROFIT MARGIN % BY CATEGORY
-- ----------------------------------------------------------------
-- Business Question:
--   Which product categories are the most profitable
--   after deducting shipping/freight costs?
-- Metrics:
--   → Total Revenue       : Sum of product prices
--   → Total Shipping Cost : Sum of freight values
--   → Gross Profit        : Revenue minus Shipping Cost
--   → Profit Margin %     : (Gross Profit / Revenue) * 100
-- Technique: CTE + JOIN + Aggregations
-- ================================================================

WITH category_financials AS (
    -- Calculate revenue, shipping cost and gross profit per category
    SELECT 
        p.product_category_name                          AS Product_Category,
        ROUND(SUM(oi.price), 2)                          AS Total_Revenue,
        ROUND(SUM(oi.freight_value), 2)                  AS Total_Shipping_Cost,
        -- Gross Profit = Revenue - Shipping Cost
        ROUND(SUM(oi.price) - SUM(oi.freight_value), 2)  AS Gross_Profit
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)
-- Show Top 10 most profitable categories
SELECT TOP 10
    Product_Category,
    Total_Revenue,
    Total_Shipping_Cost,
    Gross_Profit,
    -- Profit Margin % = (Gross Profit / Revenue) * 100
    ROUND(Gross_Profit * 100.0 / Total_Revenue, 2)  AS Profit_Margin_Percentage
FROM category_financials
-- Exclude categories with zero revenue to avoid divide by zero
WHERE Total_Revenue > 0
ORDER BY Profit_Margin_Percentage DESC;


-- ================================================================
-- STEP 4: AVERAGE ORDER VALUE (AOV)
-- ----------------------------------------------------------------
-- Business Question:
--   How much does an average customer spend per order?
-- Metrics:
--   → Total Orders       : Count of delivered orders
--   → Avg Order Value    : Average payment per order
--   → Avg Items Per Order: Average products per order
--   → Min / Max Order    : Cheapest and most expensive orders
-- Technique: CTE + Multiple JOINs + Aggregations
-- ================================================================

WITH order_totals AS (
    -- Calculate total value and item count per order
    SELECT 
        o.order_id,
        o.customer_id,
        o.order_status,
        ROUND(SUM(p.payment_value), 2)      AS Order_Value,
        COUNT(oi.order_item_id)             AS Items_Per_Order
    FROM olist_orders_dataset o
    -- Join with payments to get order payment value
    JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    -- Join with order items to count products per order
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    -- Only include successfully delivered orders
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id, o.customer_id, o.order_status
)
-- Compute overall AOV and order statistics
SELECT
    COUNT(DISTINCT order_id)            AS Total_Orders,
    ROUND(AVG(Order_Value), 2)          AS Avg_Order_Value,
    ROUND(AVG(Items_Per_Order), 2)      AS Avg_Items_Per_Order,
    ROUND(MIN(Order_Value), 2)          AS Min_Order_Value,
    ROUND(MAX(Order_Value), 2)          AS Max_Order_Value
FROM order_totals;


-- ================================================================
-- STEP 5: CUSTOMER RETENTION ANALYSIS
-- ----------------------------------------------------------------
-- Business Question:
--   How many customers are loyal vs one-time buyers?
-- Segments:
--   → One-Time Buyer    : Ordered exactly 1 time
--   → Returning Customer: Ordered exactly 2 times
--   → Loyal Customer    : Ordered 3 or more times
-- Technique: CTE + CASE WHEN + Window Function
-- ================================================================

WITH customer_orders AS (
    -- Count total orders per customer (delivered only)
    SELECT 
        customer_id,
        COUNT(order_id)                     AS Total_Orders,
        MIN(order_purchase_timestamp)       AS First_Order,
        MAX(order_purchase_timestamp)       AS Last_Order
    FROM olist_orders_dataset
    WHERE order_status = 'delivered'
    GROUP BY customer_id
),
customer_segments AS (
    -- Assign each customer to a segment based on order count
    SELECT *,
        CASE 
            WHEN Total_Orders = 1  THEN 'One-Time Buyer'
            WHEN Total_Orders = 2  THEN 'Returning Customer'
            WHEN Total_Orders >= 3 THEN 'Loyal Customer'
        END AS Customer_Segment
    FROM customer_orders
)
-- Summarize each segment with count and percentage
SELECT 
    Customer_Segment,
    COUNT(customer_id)                              AS Total_Customers,
    ROUND(AVG(CAST(Total_Orders AS FLOAT)), 2)      AS Avg_Orders,
    -- Calculate % share of each segment using Window Function
    ROUND(COUNT(customer_id) * 100.0 / 
        SUM(COUNT(customer_id)) OVER(), 2)          AS Percentage
FROM customer_segments
GROUP BY Customer_Segment
ORDER BY Total_Customers DESC;


-- ================================================================
-- STEP 6: MONTHLY REVENUE TREND
-- ----------------------------------------------------------------
-- Business Question:
--   How has revenue grown or changed month over month?
-- Metrics:
--   → Order Month    : Year-Month format (yyyy-MM)
--   → Total Orders   : Orders placed that month
--   → Monthly Revenue: Total revenue earned that month
-- Technique: FORMAT() + GROUP BY + JOIN
-- ================================================================

SELECT 
    -- Format timestamp to Year-Month for monthly grouping
    FORMAT(o.order_purchase_timestamp, 'yyyy-MM')   AS Order_Month,
    COUNT(DISTINCT o.order_id)                       AS Total_Orders,
    ROUND(SUM(p.payment_value), 2)                   AS Monthly_Revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
-- Only include delivered orders for accurate revenue tracking
WHERE o.order_status = 'delivered'
GROUP BY FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
ORDER BY Order_Month;


-- ================================================================
-- STEP 7: REVENUE BY PAYMENT TYPE
-- ----------------------------------------------------------------
-- Business Question:
--   Which payment methods do customers prefer most?
-- Metrics:
--   → Payment Method   : credit_card, boleto, voucher etc.
--   → Total Orders     : Orders using that payment method
--   → Total Revenue    : Revenue from that payment method
--   → Avg Payment Value: Average transaction value
-- Technique: GROUP BY + Aggregations
-- ================================================================

SELECT 
    payment_type                            AS Payment_Method,
    COUNT(DISTINCT order_id)                AS Total_Orders,
    ROUND(SUM(payment_value), 2)            AS Total_Revenue,
    ROUND(AVG(payment_value), 2)            AS Avg_Payment_Value
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY Total_Revenue DESC;


-- ================================================================
-- STEP 8: TOP 10 SELLERS BY REVENUE
-- ----------------------------------------------------------------
-- Business Question:
--   Which sellers generate the most revenue on the platform?
-- Metrics:
--   → Seller ID        : Unique seller identifier
--   → Total Orders     : Orders fulfilled by seller
--   → Total Revenue    : Revenue generated by seller
--   → Avg Product Price: Average price of seller's products
-- Technique: GROUP BY + Aggregations
-- ================================================================

SELECT TOP 10
    oi.seller_id                            AS Seller_ID,
    COUNT(DISTINCT oi.order_id)             AS Total_Orders,
    ROUND(SUM(oi.price), 2)                 AS Total_Revenue,
    ROUND(AVG(oi.price), 2)                 AS Avg_Product_Price
FROM olist_order_items_dataset oi
GROUP BY oi.seller_id
ORDER BY Total_Revenue DESC;


-- ================================================================
-- STEP 9: ORDER DELIVERY PERFORMANCE
-- ----------------------------------------------------------------
-- Business Question:
--   How efficiently are orders being delivered?
-- Metrics:
--   → Total Orders       : All delivered orders
--   → On Time Deliveries : Delivered on or before estimated date
--   → Late Deliveries    : Delivered after estimated date
--   → On Time Percentage : % of orders delivered on time
-- Technique: CASE WHEN + Aggregations + Date Comparison
-- ================================================================

SELECT 
    COUNT(order_id)                             AS Total_Orders,
    -- Count orders delivered on or before estimated date
    SUM(CASE 
        WHEN order_delivered_customer_date 
            <= order_estimated_delivery_date 
        THEN 1 ELSE 0 END)                      AS On_Time_Deliveries,
    -- Count orders delivered after estimated date
    SUM(CASE 
        WHEN order_delivered_customer_date 
            > order_estimated_delivery_date 
        THEN 1 ELSE 0 END)                      AS Late_Deliveries,
    -- Calculate on-time delivery rate as a percentage
    ROUND(SUM(CASE 
        WHEN order_delivered_customer_date 
            <= order_estimated_delivery_date 
        THEN 1 ELSE 0 END) * 100.0 
        / COUNT(order_id), 2)                   AS On_Time_Percentage
FROM olist_orders_dataset
-- Only consider delivered orders with valid delivery dates
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;


-- ================================================================
-- STEP 10: KEY BUSINESS METRICS SUMMARY
-- ----------------------------------------------------------------
-- Business Question:
--   What are the most critical KPIs for the README
--   and final project report?
-- ================================================================

-- 10A: Top 5 Categories % of Total Revenue
WITH product_revenue AS (
    -- Get revenue per product category
    SELECT 
        p.product_category_name         AS Product_Category,
        ROUND(SUM(oi.price), 2)         AS Total_Revenue
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)
-- Calculate what % top 5 categories contribute to total
SELECT 
    ROUND(SUM(Total_Revenue) * 100.0 / 
        (SELECT SUM(price) FROM olist_order_items_dataset), 2) AS Top5_Revenue_Percentage
FROM (
    SELECT TOP 5 Total_Revenue
    FROM product_revenue
    ORDER BY Total_Revenue DESC
) AS top5;


-- 10B: Overall Average Order Value (AOV)
-- Formula: Total Revenue / Total Unique Orders
SELECT 
    ROUND(SUM(payment_value) / 
        COUNT(DISTINCT order_id), 2)    AS Avg_Order_Value
FROM olist_order_payments_dataset;


-- 10C: One-Time Buyer Percentage
-- Customers who placed exactly 1 delivered order
WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(order_id)                 AS Total_Orders
    FROM olist_orders_dataset
    WHERE order_status = 'delivered'
    GROUP BY customer_id
)
SELECT 
    ROUND(SUM(CASE 
        WHEN Total_Orders = 1 
        THEN 1 ELSE 0 END) * 100.0 / 
        COUNT(customer_id), 2)          AS One_Time_Buyer_Percentage
FROM customer_orders;


-- 10D: On-Time Delivery Rate
-- % of orders delivered on or before estimated date
SELECT 
    ROUND(SUM(CASE 
        WHEN order_delivered_customer_date 
            <= order_estimated_delivery_date 
        THEN 1 ELSE 0 END) * 100.0 / 
        COUNT(order_id), 2)             AS On_Time_Delivery_Percentage
FROM olist_orders_dataset
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;


-- ================================================================
--                     END OF PROJECT
--         E-Commerce Sales Analysis | Harsh Vaibhav
-- ================================================================
