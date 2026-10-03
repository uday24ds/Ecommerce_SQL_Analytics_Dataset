USE EcommerceAnalytics;
GO

/*
============================================================
E-COMMERCE SALES & CUSTOMER ANALYTICS
DATA CLEANING & PREPARATION
============================================================

Purpose:
Prepare cleaned tables from the imported CSV data.

Raw tables:
    customers
    orders
    order_items
    payments
    products

Cleaned tables:
    customers_clean
    orders_clean
    order_items_clean
    payments_clean
    products_clean
============================================================
*/


/* =========================================================
   1. CUSTOMERS
   ========================================================= */

IF OBJECT_ID('dbo.customers_clean', 'U') IS NOT NULL
    DROP TABLE dbo.customers_clean;
GO

SELECT
    customer_id,
    LTRIM(RTRIM(customer_name)) AS customer_name,
    LTRIM(RTRIM(city)) AS city
INTO dbo.customers_clean
FROM dbo.customers;
GO


/* =========================================================
   2. ORDERS
   ========================================================= */

IF OBJECT_ID('dbo.orders_clean', 'U') IS NOT NULL
    DROP TABLE dbo.orders_clean;
GO

SELECT
    order_id,
    customer_id,
    CAST(order_date AS DATE) AS order_date,
    LTRIM(RTRIM(order_status)) AS order_status
INTO dbo.orders_clean
FROM dbo.orders;
GO


/* =========================================================
   3. ORDER ITEMS
   ========================================================= */

IF OBJECT_ID('dbo.order_items_clean', 'U') IS NOT NULL
    DROP TABLE dbo.order_items_clean;
GO

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    CAST(unit_price AS DECIMAL(18,2)) AS unit_price
INTO dbo.order_items_clean
FROM dbo.order_items;
GO


/* =========================================================
   4. PAYMENTS
   ========================================================= */

IF OBJECT_ID('dbo.payments_clean', 'U') IS NOT NULL
    DROP TABLE dbo.payments_clean;
GO

SELECT
    payment_id,
    order_id,
    CAST(payment_date AS DATE) AS payment_date,
    LTRIM(RTRIM(payment_status)) AS payment_status,
    CAST(payment_amount AS DECIMAL(18,2)) AS payment_amount
INTO dbo.payments_clean
FROM dbo.payments;
GO


/* =========================================================
   5. PRODUCTS
   ========================================================= */

IF OBJECT_ID('dbo.products_clean', 'U') IS NOT NULL
    DROP TABLE dbo.products_clean;
GO

SELECT
    product_id,
    LTRIM(RTRIM(product_name)) AS product_name,
    LTRIM(RTRIM(category)) AS category,
    LTRIM(RTRIM(sub_category)) AS sub_category
INTO dbo.products_clean
FROM dbo.products;
GO


/*
============================================================
CLEANING & PREPARATION COMPLETE
============================================================
*/