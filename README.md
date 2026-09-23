# 🛒 E-Commerce Sales Analysis | SQL Server

## 📌 Project Overview

This project analyzes an e-commerce dataset to understand **sales performance, customer purchasing behavior, product performance, seller performance, payment trends, and delivery operations** using SQL.

The goal was not only to calculate business metrics, but to use SQL to answer practical business questions and identify patterns that could support better decision-making.

The project uses the **Brazilian E-Commerce Public Dataset by Olist**, containing 100,000+ e-commerce transactions across multiple related tables.

---

## 🎯 Business Objectives

The analysis focuses on answering key business questions:

### Revenue & Sales

* What is the total revenue generated?
* How does revenue change over time?
* What is the average order value?
* Which products and categories generate the most revenue?
* Which sellers contribute the most to sales?

### Customer Analysis

* How many customers are one-time vs repeat buyers?
* Who are the highest-value customers?
* What is the purchasing behavior of customers?
* How does customer purchasing contribute to overall revenue?

### Product Analysis

* Which products are the best performers?
* Which categories generate the highest revenue?
* What are the most profitable categories?
* How do products rank within their categories?

### Payment Analysis

* Which payment methods are most commonly used?
* How does payment behavior vary across customers and orders?

### Delivery & Operations

* How long does it take to deliver orders?
* How does actual delivery compare with estimated delivery?
* What percentage of orders are delivered on time?
* Which sellers/categories have delivery performance issues?

---

## 🗂️ Dataset

The project uses the **Brazilian E-Commerce Public Dataset by Olist**.

The dataset contains multiple related tables, including:

* Customers
* Orders
* Order Items
* Products
* Sellers
* Payments
* Reviews
* Product Category Translation

### Key relationships

```text
Customers
    │
    │ customer_id
    ↓
Orders
    │
    ├──────────────→ Payments
    │
    ├──────────────→ Reviews
    │
    ↓
Order Items
    │
    ├──────────────→ Products
    │
    └──────────────→ Sellers
```

This relational structure allowed me to perform multi-table analysis using SQL JOINs.

---

## 🛠️ Tools & Technologies

* **SQL Server**
* SQL
* GitHub
* Olist Brazilian E-Commerce Dataset

### SQL Concepts Used

* SELECT / WHERE / ORDER BY
* GROUP BY / HAVING
* Aggregate Functions
* INNER JOIN
* LEFT JOIN
* Multiple JOINs
* Subqueries
* Common Table Expressions (CTEs)
* CASE statements
* Date & Time Functions
* Window Functions
* `ROW_NUMBER()`
* `RANK()`
* `DENSE_RANK()`
* `LAG()`
* `LEAD()`

---

## 📊 Analysis Performed

### 1. Overall Sales Performance

Analyzed:

* Total revenue
* Total orders
* Total customers
* Average Order Value
* Revenue trends
* Monthly sales performance

---

### 2. Product & Category Performance

Analyzed:

* Top-performing products
* Revenue by category
* Profit margin by category
* Product rankings
* Seller contribution to revenue

Window functions were used to rank products and sellers based on their performance.

---

### 3. Customer Analysis

Analyzed:

* One-time vs repeat customers
* Customer purchasing behavior
* Customer spending
* High-value customers

Customer-level analysis was performed using aggregations, JOINs, CTEs and subqueries.

---

### 4. Payment Analysis

Analyzed:

* Payment method distribution
* Number of payments per order
* Payment value by method
* Customer payment behavior

---

### 5. Delivery Performance

Analyzed:

* Average delivery time
* Estimated vs actual delivery
* On-time delivery performance
* Delivery performance across sellers/categories

---

## 🧠 Advanced SQL Analysis

The project also demonstrates advanced SQL techniques.

### Window Functions

Used window functions to perform analysis without collapsing individual records.

Examples include:

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
LAG()
LEAD()
```

These techniques can be used for:

* Ranking products
* Identifying first purchases
* Comparing current vs previous periods
* Analyzing customer purchase behavior
* Measuring changes over time

---

## 📈 Key Findings

> This section will contain findings calculated directly from the dataset.

Examples of the type of insights being investigated:

* Percentage of customers who make only one purchase
* Revenue contribution of repeat customers
* Highest-performing product categories
* Top-performing sellers
* Monthly revenue trends
* Average order value
* Delivery performance
* Payment method preferences

**All numerical findings will be calculated from the dataset rather than manually estimated.**

---

## 💡 Business Insights & Recommendations

The analysis is intended to translate SQL results into actionable business insights.

Potential areas include:

* Improving customer retention
* Identifying high-value customers
* Understanding product/category performance
* Improving delivery operations
* Identifying changes in monthly revenue
* Understanding customer purchasing behavior

Recommendations will be based on the actual analytical findings from the dataset.

---

## 🚀 Future Analysis

The project will be extended with deeper customer and retention analytics:

### Customer Purchase Gap Analysis

Using `LAG()` to calculate the time between consecutive customer purchases.

### First vs Repeat Purchase Analysis

Using `ROW_NUMBER()` to identify first purchases and subsequent purchases.

### Revenue Growth Analysis

Using `LAG()` to calculate:

* Previous month's revenue
* Revenue change
* Month-over-month growth

### Product Ranking

Using `RANK()` and `DENSE_RANK()` to identify the top products within each category.

### RFM Customer Segmentation

Customers will be segmented based on:

* **Recency**
* **Frequency**
* **Monetary Value**

### Cohort Retention Analysis

Customers will be grouped based on their first purchase period to analyze repeat purchasing and retention over time.

---

## 📁 Project Structure

```text
ecommerce-sales-analysis-sql/
│
├── README.md
│
├── Olist_E_Commerce.sql
│
└── ...
```

The SQL file contains the queries used for the analysis.

---

## 🎓 Key Takeaways

This project demonstrates my ability to use SQL to move from **raw transactional data to business insights**.

Through this analysis, I practiced:

```text
Data Exploration
      ↓
Data Aggregation
      ↓
Multi-table JOINs
      ↓
Subqueries & CTEs
      ↓
Window Functions
      ↓
Customer & Revenue Analysis
      ↓
Business Insights
```

The project is being continuously expanded to include deeper **customer retention, segmentation, and behavioral analysis**.

---

## 👤 Author

**Harsh Vaibhav**

PGDM — Business Analytics

Interested in **Data Analytics | Business Analytics | SQL | Power BI | Business Intelligence**

[GitHub](https://github.com/HarshVaibhav)
st - Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
