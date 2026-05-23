-- ============================================================
-- E-Commerce Sales Analysis | SQL Server
-- Dataset: Brazilian Olist E-Commerce (Kaggle)
-- Author: Your Name
-- Date: January 2026
-- ============================================================

USE OlistEcommerce;

-- ============================================================
-- STEP 1: TOTAL REVENUE, ORDERS & CUSTOMERS
-- ============================================================

SELECT 
    ROUND(SUM(payment_value), 2)         AS Total_Revenue,
    COUNT(DISTINCT order_id)             AS Total_Orders,
    (SELECT COUNT(DISTINCT customer_id) 
     FROM olist_customers_dataset)       AS Total_Customers
FROM olist_order_payments_dataset;


-- ============================================================
-- STEP 2: TOP 5 REVENUE GENERATING PRODUCTS
-- (Uses CTE + JOIN + Window Function RANK)
-- ============================================================

WITH product_revenue AS (
    SELECT 
        p.product_category_name             AS Product_Category,
        ROUND(SUM(oi.price), 2)             AS Total_Revenue,
        COUNT(DISTINCT oi.order_id)         AS Total_Orders
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
),
ranked_products AS (
    SELECT *,
        RANK() OVER (ORDER BY Total_Revenue DESC) AS Revenue_Rank
    FROM product_revenue
)
SELECT TOP 5
    Revenue_Rank,
    Product_Category,
    Total_Revenue,
    Total_Orders,
    ROUND(Total_Revenue * 100.0 / SUM(Total_Revenue) OVER(), 2) AS Revenue_Percentage
FROM ranked_products
ORDER BY Revenue_Rank;


-- ============================================================
-- STEP 3: PROFIT MARGIN % BY CATEGORY
-- (Uses CTE + JOIN + Aggregations)
-- ============================================================

WITH category_financials AS (
    SELECT 
        p.product_category_name                          AS Product_Category,
        ROUND(SUM(oi.price), 2)                          AS Total_Revenue,
        ROUND(SUM(oi.freight_value), 2)                  AS Total_Shipping_Cost,
        ROUND(SUM(oi.price) - SUM(oi.freight_value), 2)  AS Gross_Profit
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)
SELECT TOP 10
    Product_Category,
    Total_Revenue,
    Total_Shipping_Cost,
    Gross_Profit,
    ROUND(Gross_Profit * 100.0 / Total_Revenue, 2)  AS Profit_Margin_Percentage
FROM category_financials
WHERE Total_Revenue > 0
ORDER BY Profit_Margin_Percentage DESC;


-- ============================================================
-- STEP 4: AVERAGE ORDER VALUE (AOV)
-- (Uses CTE + Multiple JOINs + Aggregations)
-- ============================================================

WITH order_totals AS (
    SELECT 
        o.order_id,
        o.customer_id,
        o.order_status,
        ROUND(SUM(p.payment_value), 2)      AS Order_Value,
        COUNT(oi.order_item_id)             AS Items_Per_Order
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id, o.customer_id, o.order_status
)
SELECT
    COUNT(DISTINCT order_id)            AS Total_Orders,
    ROUND(AVG(Order_Value), 2)          AS Avg_Order_Value,
    ROUND(AVG(Items_Per_Order), 2)      AS Avg_Items_Per_Order,
    ROUND(MIN(Order_Value), 2)          AS Min_Order_Value,
    ROUND(MAX(Order_Value), 2)          AS Max_Order_Value
FROM order_totals;


-- ============================================================
-- STEP 5: CUSTOMER RETENTION ANALYSIS
-- (Uses CTE + CASE WHEN + Window Function)
-- ============================================================

WITH customer_orders AS (
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
    SELECT *,
        CASE 
            WHEN Total_Orders = 1  THEN 'One-Time Buyer'
            WHEN Total_Orders = 2  THEN 'Returning Customer'
            WHEN Total_Orders >= 3 THEN 'Loyal Customer'
        END AS Customer_Segment
    FROM customer_orders
)
SELECT 
    Customer_Segment,
    COUNT(customer_id)                              AS Total_Customers,
    ROUND(AVG(CAST(Total_Orders AS FLOAT)), 2)      AS Avg_Orders,
    ROUND(COUNT(customer_id) * 100.0 / 
        SUM(COUNT(customer_id)) OVER(), 2)          AS Percentage
FROM customer_segments
GROUP BY Customer_Segment
ORDER BY Total_Customers DESC;


-- ============================================================
-- STEP 6: MONTHLY REVENUE TREND
-- (Uses FORMAT + GROUP BY + JOINs)
-- ============================================================

SELECT 
    FORMAT(o.order_purchase_timestamp, 'yyyy-MM')   AS Order_Month,
    COUNT(DISTINCT o.order_id)                       AS Total_Orders,
    ROUND(SUM(p.payment_value), 2)                   AS Monthly_Revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
ORDER BY Order_Month;


-- ============================================================
-- STEP 7: REVENUE BY PAYMENT TYPE
-- (Uses GROUP BY + Aggregations)
-- ============================================================

SELECT 
    payment_type                            AS Payment_Method,
    COUNT(DISTINCT order_id)                AS Total_Orders,
    ROUND(SUM(payment_value), 2)            AS Total_Revenue,
    ROUND(AVG(payment_value), 2)            AS Avg_Payment_Value
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY Total_Revenue DESC;


-- ============================================================
-- STEP 8: TOP 10 SELLERS BY REVENUE
-- (Uses GROUP BY + Aggregations)
-- ============================================================

SELECT TOP 10
    oi.seller_id                            AS Seller_ID,
    COUNT(DISTINCT oi.order_id)             AS Total_Orders,
    ROUND(SUM(oi.price), 2)                 AS Total_Revenue,
    ROUND(AVG(oi.price), 2)                 AS Avg_Product_Price
FROM olist_order_items_dataset oi
GROUP BY oi.seller_id
ORDER BY Total_Revenue DESC;


-- ============================================================
-- STEP 9: ORDER DELIVERY PERFORMANCE
-- (Uses CASE WHEN + Aggregations)
-- ============================================================

SELECT 
    COUNT(order_id)                             AS Total_Orders,
    SUM(CASE 
        WHEN order_delivered_customer_date 
            <= order_estimated_delivery_date 
        THEN 1 ELSE 0 END)                      AS On_Time_Deliveries,
    SUM(CASE 
        WHEN order_delivered_customer_date 
            > order_estimated_delivery_date 
        THEN 1 ELSE 0 END)                      AS Late_Deliveries,
    ROUND(SUM(CASE 
        WHEN order_delivered_customer_date 
            <= order_estimated_delivery_date 
        THEN 1 ELSE 0 END) * 100.0 
        / COUNT(order_id), 2)                   AS On_Time_Percentage
FROM olist_orders_dataset
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;


-- ============================================================
-- END OF PROJECT
-- ============================================================