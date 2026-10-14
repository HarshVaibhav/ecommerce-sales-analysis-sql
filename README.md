# E-Commerce Sales Analysis — SQL Server

> SQL-driven analysis of the Brazilian Olist e-commerce dataset, focused on sales performance, customer behavior, product performance, payments, sellers, and delivery operations.

## Overview

This portfolio project uses SQL Server to turn a multi-table e-commerce dataset into business-focused analysis. The objective is to answer practical questions around revenue, customers, products, sellers, payments, and delivery performance.

**Dataset:** Brazilian E-Commerce Public Dataset by Olist  
**Scale:** 100,000+ transactions across related tables

## Business Questions

### Sales & Revenue
- How much revenue was generated?
- How does revenue change over time?
- What is the average order value?
- Which products, categories, and sellers contribute most to sales?

### Customer Behavior
- Which customers are one-time vs. repeat buyers?
- Who are the highest-value customers?
- How does customer purchasing behavior contribute to revenue?

### Product Performance
- Which products and categories perform best?
- How do products rank within categories?
- Which categories show stronger commercial performance?

### Payments
- Which payment methods are most frequently used?
- How does payment value vary by payment method?

### Delivery Operations
- What is the average delivery time?
- How does actual delivery compare with the estimated date?
- Which sellers or categories show delivery-performance issues?

## Dataset Structure

The analysis uses related Olist tables including Customers, Orders, Order Items, Products, Sellers, Payments, Reviews, and Product Category Translation.

## SQL Skills Demonstrated

- Filtering and sorting
- Aggregations and GROUP BY
- HAVING
- Multi-table INNER JOIN and LEFT JOIN
- Subqueries
- Common Table Expressions (CTEs)
- CASE
- Date/time functions
- Window functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- LEAD()

## Analysis Areas

1. **Sales performance** — revenue, orders, customers, AOV, and trends
2. **Product & category performance** — rankings, revenue contribution, and seller contribution
3. **Customer analysis** — purchase frequency, spending, and repeat behavior
4. **Payment analysis** — payment methods, values, and order-level payment behavior
5. **Delivery analysis** — delivery time, estimated vs. actual delivery, and operational performance

## Repository Structure

    ecommerce-sales-analysis-sql/
    ├── README.md
    └── Olist_E_Commerce.sql

## Key Takeaway

This project demonstrates an end-to-end SQL workflow:

**Data exploration → joins → aggregation → CTEs/subqueries → window functions → business analysis**

## Author

**Harsh Vaibhav**  
PGDM — Business Analytics

Focus areas: **Data Analytics · Business Analytics · SQL · Power BI · Business Intelligence**

- [GitHub Profile](https://github.com/HarshVaibhav)
- [Olist Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
