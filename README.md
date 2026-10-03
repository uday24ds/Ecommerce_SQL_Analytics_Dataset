# E-Commerce Sales & Customer Analytics Using SQL Server

## 📌 Project Overview

This project analyzes e-commerce sales, customer behavior, product performance, geographic performance, time-based trends, and payment activity using **Microsoft SQL Server**.

The project focuses on transforming raw e-commerce data into structured analytical datasets and answering practical business questions using SQL.

The analysis demonstrates SQL skills ranging from data validation and aggregation to advanced window functions and analytical queries.

---

## 🎯 Business Questions

The project addresses questions such as:

* What are the overall sales and order performance metrics?
* What is the average order value?
* Which customers generate the most revenue?
* How concentrated is revenue among high-value customers?
* Who are the top customers within each city?
* Which products and categories generate the most revenue?
* Which products have the highest sales volume?
* Which cities generate the most revenue?
* What is the revenue contribution of different cities and categories?
* How does revenue change year over year?
* How does monthly revenue change over time?
* Which orders have multiple payment attempts?
* Which orders do not have payment records?
* How do recorded payments compare with order-level sales?
* What patterns and data-quality issues can be identified from the dataset?

---

## 🗂️ Dataset

The project uses an e-commerce dataset containing five primary data sources:

* Customers
* Orders
* Order Items
* Payments
* Products

The raw data was imported into SQL Server and transformed into cleaned analytical tables before analysis.

---

## 🏗️ Data Preparation

The project includes a cleaning and preparation layer before analytical queries are executed.

Cleaned tables include:

```text
customers_clean
orders_clean
order_items_clean
payments_clean
products_clean
```

Data validation includes checks for:

* Duplicate records
* Missing values
* Orphan records
* Invalid relationships
* Sales reconciliation
* Payment coverage
* Product and customer coverage

---

## 📊 Analytics Layer

Reusable SQL views were created to simplify downstream analysis.

```text
vw_order_sales
    ↓
One row per order

vw_customer_sales
    ↓
One row per customer

vw_product_sales
    ↓
One row per product

vw_payment_summary
    ↓
One row per order with payment activity
```

These views provide a reusable analytical foundation instead of repeatedly rebuilding the same calculations.

---

## 🔍 Analysis Areas

### 1. Sales Performance

Analysis includes:

* Total orders
* Total sales
* Average order value
* Minimum and maximum order value
* Sales by order status

### 2. Customer Analysis

Analysis includes:

* Top customers by revenue
* Customer revenue contribution
* Customer purchase frequency
* Top customers within each city
* Customer revenue ranking
* Customer revenue deciles

### 3. Product & Category Analysis

Analysis includes:

* Top products by revenue
* Products by units sold
* Category performance
* Sub-category performance
* Top products within each category
* Product revenue contribution

### 4. Geographic Analysis

Analysis includes:

* Revenue by city
* Customer count by city
* Orders by city
* Revenue per customer
* City-level customer ranking

### 5. Time & Growth Analysis

Analysis includes:

* Yearly sales
* Monthly sales
* Year-over-year growth
* Month-over-month analysis
* Cumulative revenue
* Best and lowest-performing periods

### 6. Payment Analysis

Analysis includes:

* Payment status distribution
* Payment amounts
* Multiple payment attempts
* Orders without payment records
* Payment/order reconciliation
* Payment coverage

---

## 🧠 SQL Techniques Demonstrated

This project demonstrates:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `INNER JOIN`
* `LEFT JOIN`
* `CASE`
* Common Table Expressions (`CTE`)
* Aggregate functions
* `ROW_NUMBER()`
* `RANK()`
* `DENSE_RANK()`
* `NTILE()`
* `LAG()`
* Window functions
* Running totals
* Revenue contribution calculations
* Year-over-year calculations
* Data validation
* Reconciliation analysis

---

## 📁 Project Structure

```text
EcommerceAnalytics/
│
├── README.md
│
├── SQL/
│   ├── 01_Cleaning_and_Preparation.sql
│   ├── 02_Analytics_Views.sql
│   └── 03_EcommerceAnalytics_Analysis.sql
│
└── Data/
    └── README.md
```

---

## ▶️ How to Run

### 1. Install SQL Server

Install Microsoft SQL Server and SQL Server Management Studio (SSMS).

### 2. Create the database

```sql
CREATE DATABASE EcommerceAnalytics;
```

### 3. Import the dataset

Import the five source datasets into the database.

### 4. Run the cleaning and preparation script

Run:

```text
01_Cleaning_and_Preparation.sql
```

### 5. Create the analytical views

Run:

```text
02_Analytics_Views.sql
```

The following views will be created:

```text
vw_order_sales
vw_customer_sales
vw_product_sales
vw_payment_summary
```

### 6. Run the analysis

Run:

```text
03_EcommerceAnalytics_Analysis.sql
```

The queries are organized by business-analysis area.

---

## 📌 Key Project Outcome

The project demonstrates how raw e-commerce transaction data can be transformed into a structured SQL analytics layer and used to answer practical business questions.

Rather than relying only on basic aggregations, the project uses reusable views, window functions, ranking techniques, time-series analysis, customer segmentation, geographic analysis, and data-quality validation.

---

## 🚀 Future Improvements

Potential future extensions include:

* Connecting the SQL Server database to Power BI
* Building an interactive sales dashboard
* Creating automated data-refresh workflows
* Adding customer lifetime value analysis
* Adding retention and cohort analysis
* Developing product profitability analysis when cost data is available
* Automating recurring analytical reports

---

## 🛠️ Tools Used

* **Microsoft SQL Server**
* **SQL Server Management Studio (SSMS)**
* **SQL**
* **GitHub**

---

## 👤 Author

**Udaysingh Ganesh Rathod**

Data Analytics Portfolio Project
