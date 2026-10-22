# E-Commerce Sales Analysis — SQL Server

A SQL Server portfolio project analyzing the Brazilian Olist e-commerce dataset to explore sales performance, customer purchasing behavior, product categories, payments, sellers, and delivery operations.

## Project Overview

This project uses relational e-commerce tables and business-focused SQL queries to answer practical questions about revenue, orders, customers, category performance, payments, and delivery outcomes.

- **Dataset:** Brazilian E-Commerce Public Dataset by Olist
- **Database:** SQL Server
- **Primary analysis file:** `Olist_E_Commerce.sql`
- **Tools:** SQL Server Management Studio (SSMS), T-SQL

## Business Questions

### Sales and Revenue
- What are the overall revenue, order, and customer totals?
- How does revenue change over time?
- What is the average order value?
- Which product categories and sellers contribute the most item-price revenue?

### Customer Behavior
- How frequently do customers purchase?
- Which customers have the highest order activity?
- What does repeat-purchase behavior look like in the available data?

### Payments and Operations
- Which payment types are most commonly used and what is their payment value?
- How long do deliveries take?
- How does actual delivery compare with the estimated delivery date?

## SQL Techniques Demonstrated

- Filtering, sorting, and aggregation
- `GROUP BY` and `HAVING`
- Multi-table `INNER JOIN` and `LEFT JOIN`
- Common Table Expressions (CTEs) and subqueries
- `CASE` expressions and date functions
- Window functions: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LAG()`, and `LEAD()`

## Repository Structure

```text
ecommerce-sales-analysis-sql/
├── README.md
└── Olist_E_Commerce.sql
```

## How to Run

1. Download the Olist dataset from the [Kaggle dataset page](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
2. Import the required CSV files into a SQL Server database.
3. Confirm the database name and table names match the script. The script starts with `USE OlistEcommerce;`.
4. Open `Olist_E_Commerce.sql` in SSMS and execute the queries after the data has been loaded.

The script expects the Olist tables to exist in the database; it does not create or import the tables itself.

## Metric Notes

- Revenue measures in individual queries depend on the underlying Olist table and field used. For example, product/category analysis uses item prices, while the overall payment snapshot sums payment values.
- Freight is a delivery charge, not product cost. The category-level calculation that subtracts freight from item price should be interpreted as **contribution after freight**, not accounting gross profit or full profit margin.
- Results describe the dataset and should not be interpreted as current performance for a live retailer.

## Workflow

**Load data → explore relational tables → join and aggregate → apply CTEs/window functions → interpret business metrics**

## Author

**Harsh Vaibhav**  
PGDM — Business Analytics

Focus areas: **Data Analytics · Business Analytics · SQL · Power BI · Business Intelligence**

- [GitHub Profile](https://github.com/HarshVaibhav)
- [Olist Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
