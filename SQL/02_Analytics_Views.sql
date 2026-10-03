USE EcommerceAnalytics;
GO

/*
============================================================
E-COMMERCE SALES & CUSTOMER ANALYTICS
ANALYTICS VIEWS
============================================================

Database: EcommerceAnalytics

Views:
    1. vw_order_sales
    2. vw_customer_sales
    3. vw_product_sales
    4. vw_payment_summary
============================================================
*/


/* =========================================================
   1. ORDER SALES VIEW
   One row per order
   ========================================================= */

CREATE OR ALTER VIEW dbo.vw_order_sales
AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    CAST(SUM(oi.quantity * oi.unit_price) AS DECIMAL(18,2))
        AS order_sales
FROM dbo.orders_clean AS o
INNER JOIN dbo.order_items_clean AS oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status;
GO


/* =========================================================
   2. CUSTOMER SALES VIEW
   One row per customer with orders
   ========================================================= */

CREATE OR ALTER VIEW dbo.vw_customer_sales
AS
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(v.order_id) AS total_orders,
    CAST(SUM(v.order_sales) AS DECIMAL(18,2)) AS total_sales,
    CAST(AVG(v.order_sales) AS DECIMAL(18,2))
        AS average_order_value
FROM dbo.customers_clean AS c
INNER JOIN dbo.vw_order_sales AS v
    ON c.customer_id = v.customer_id
GROUP BY
    c.customer_id,
    c.customer_name;
GO


/* =========================================================
   3. PRODUCT SALES VIEW
   One row per product
   ========================================================= */

CREATE OR ALTER VIEW dbo.vw_product_sales
AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    SUM(oi.quantity) AS units_sold,
    CAST(
        SUM(oi.quantity * oi.unit_price)
        AS DECIMAL(18,2)
    ) AS total_sales
FROM dbo.products_clean AS p
INNER JOIN dbo.order_items_clean AS oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category;
GO


/* =========================================================
   4. PAYMENT SUMMARY VIEW
   One row per order with payment activity
   ========================================================= */

CREATE OR ALTER VIEW dbo.vw_payment_summary
AS
SELECT
    p.order_id,
    COUNT(*) AS payment_count,
    MAX(p.payment_date) AS latest_payment_date,
    CAST(
        SUM(p.payment_amount)
        AS DECIMAL(18,2)
    ) AS total_payment_amount
FROM dbo.payments_clean AS p
GROUP BY
    p.order_id;
GO