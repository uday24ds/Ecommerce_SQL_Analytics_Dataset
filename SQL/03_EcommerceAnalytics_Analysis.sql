USE EcommerceAnalytics;
GO

/*
============================================================
E-COMMERCE SALES & CUSTOMER ANALYTICS
SQL SERVER PORTFOLIO PROJECT
============================================================

Database: EcommerceAnalytics
Platform: Microsoft SQL Server

Purpose:
Analyze sales performance, customers, products,
geographic performance, time trends, and payments.

Analytics Views:
    vw_order_sales
    vw_customer_sales
    vw_product_sales
    vw_payment_summary
============================================================
*/


/*
============================================================
01 - DATA VALIDATION
============================================================
*/

-- 1. Check duplicate customers

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM dbo.customers_clean
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 2. Check duplicate products

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM dbo.products_clean
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 3. Check orphan order items

SELECT
    COUNT(*) AS orphan_order_items
FROM dbo.order_items_clean AS oi
LEFT JOIN dbo.orders_clean AS o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 4. Check orphan products

SELECT
    COUNT(*) AS orphan_product_items
FROM dbo.order_items_clean AS oi
LEFT JOIN dbo.products_clean AS p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


/*
============================================================
02 - SALES PERFORMANCE
============================================================
*/

-- 5. Overall sales KPIs

SELECT
    COUNT(*) AS total_orders,
    CAST(SUM(order_sales) AS DECIMAL(18,2)) AS total_sales,
    CAST(AVG(order_sales) AS DECIMAL(18,2)) AS average_order_value,
    CAST(MIN(order_sales) AS DECIMAL(18,2)) AS smallest_order,
    CAST(MAX(order_sales) AS DECIMAL(18,2)) AS largest_order
FROM dbo.vw_order_sales;


-- 6. Sales by order status

SELECT
    order_status,
    COUNT(*) AS order_count,
    CAST(SUM(order_sales) AS DECIMAL(18,2)) AS total_sales
FROM dbo.vw_order_sales
GROUP BY order_status
ORDER BY total_sales DESC;


/*
============================================================
03 - CUSTOMER ANALYSIS
============================================================
*/

-- 7. Top 20 customers by revenue

SELECT TOP 20
    customer_id,
    customer_name,
    total_orders,
    CAST(total_sales AS DECIMAL(18,2)) AS total_sales,
    CAST(average_order_value AS DECIMAL(18,2)) AS average_order_value
FROM dbo.vw_customer_sales
ORDER BY total_sales DESC;


-- 8. Customer revenue contribution

SELECT
    customer_id,
    customer_name,
    total_orders,
    CAST(total_sales AS DECIMAL(18,2)) AS total_sales,
    CAST(
        total_sales * 100.0 /
        SUM(total_sales) OVER ()
        AS DECIMAL(10,2)
    ) AS revenue_contribution_pct
FROM dbo.vw_customer_sales
ORDER BY total_sales DESC;


-- 9. Top 3 customers in each city

WITH RankedCustomers AS
(
    SELECT
        c.city,
        v.customer_id,
        v.customer_name,
        v.total_orders,
        v.total_sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY c.city
            ORDER BY v.total_sales DESC
        ) AS customer_rank
    FROM dbo.vw_customer_sales AS v
    INNER JOIN dbo.customers_clean AS c
        ON v.customer_id = c.customer_id
)
SELECT
    city,
    customer_id,
    customer_name,
    total_orders,
    CAST(total_sales AS DECIMAL(18,2)) AS total_sales,
    customer_rank
FROM RankedCustomers
WHERE customer_rank <= 3
ORDER BY city, customer_rank;


/*
============================================================
04 - PRODUCT & CATEGORY ANALYSIS
============================================================
*/

-- 10. Top 20 products by revenue

SELECT TOP 20
    product_id,
    product_name,
    category,
    sub_category,
    units_sold,
    CAST(total_sales AS DECIMAL(18,2)) AS total_sales
FROM dbo.vw_product_sales
ORDER BY total_sales DESC;


-- 11. Category performance

SELECT
    category,
    SUM(units_sold) AS units_sold,
    CAST(SUM(total_sales) AS DECIMAL(18,2)) AS total_sales
FROM dbo.vw_product_sales
GROUP BY category
ORDER BY total_sales DESC;


-- 12. Top 3 products within each category

WITH RankedProducts AS
(
    SELECT
        product_id,
        product_name,
        category,
        sub_category,
        units_sold,
        total_sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS product_rank
    FROM dbo.vw_product_sales
)
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    units_sold,
    CAST(total_sales AS DECIMAL(18,2)) AS total_sales,
    product_rank
FROM RankedProducts
WHERE product_rank <= 3
ORDER BY category, product_rank;


/*
============================================================
05 - GEOGRAPHIC ANALYSIS
============================================================
*/

-- 13. Revenue by city

SELECT
    c.city,
    COUNT(DISTINCT v.customer_id) AS customers,
    COUNT(v.order_id) AS total_orders,
    CAST(SUM(v.order_sales) AS DECIMAL(18,2)) AS total_sales
FROM dbo.vw_order_sales AS v
INNER JOIN dbo.customers_clean AS c
    ON v.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_sales DESC;


-- 14. Revenue per customer by city

SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    CAST(SUM(v.order_sales) AS DECIMAL(18,2)) AS total_sales,
    CAST(
        SUM(v.order_sales) /
        NULLIF(COUNT(DISTINCT c.customer_id), 0)
        AS DECIMAL(18,2)
    ) AS revenue_per_customer
FROM dbo.vw_order_sales AS v
INNER JOIN dbo.customers_clean AS c
    ON v.customer_id = c.customer_id
GROUP BY c.city
ORDER BY revenue_per_customer DESC;


/*
============================================================
06 - TIME & GROWTH ANALYSIS
============================================================
*/

-- 15. Yearly sales performance

SELECT
    YEAR(order_date) AS order_year,
    COUNT(*) AS total_orders,
    CAST(SUM(order_sales) AS DECIMAL(18,2)) AS total_sales,
    CAST(AVG(order_sales) AS DECIMAL(18,2)) AS average_order_value
FROM dbo.vw_order_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- 16. Year-over-year revenue growth

WITH YearlySales AS
(
    SELECT
        YEAR(order_date) AS order_year,
        SUM(order_sales) AS total_sales
    FROM dbo.vw_order_sales
    GROUP BY YEAR(order_date)
),
YearlyComparison AS
(
    SELECT
        order_year,
        total_sales,
        LAG(total_sales) OVER
        (
            ORDER BY order_year
        ) AS previous_year_sales
    FROM YearlySales
)
SELECT
    order_year,
    CAST(total_sales AS DECIMAL(18,2)) AS total_sales,
    CAST(previous_year_sales AS DECIMAL(18,2)) AS previous_year_sales,
    CAST(
        (total_sales - previous_year_sales) * 100.0 /
        NULLIF(previous_year_sales, 0)
        AS DECIMAL(10,2)
    ) AS yoy_growth_pct
FROM YearlyComparison
ORDER BY order_year;


-- 17. Monthly sales trend

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(*) AS total_orders,
    CAST(SUM(order_sales) AS DECIMAL(18,2)) AS total_sales
FROM dbo.vw_order_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;


/*
============================================================
07 - PAYMENT & ORDER STATUS ANALYSIS
============================================================
*/

-- 18. Payment status distribution

SELECT
    payment_status,
    COUNT(*) AS payment_count,
    CAST(SUM(payment_amount) AS DECIMAL(18,2)) AS total_payment_amount
FROM dbo.payments_clean
GROUP BY payment_status
ORDER BY payment_count DESC;


-- 19. Orders with multiple payment attempts

SELECT
    order_id,
    payment_count,
    latest_payment_date,
    CAST(total_payment_amount AS DECIMAL(18,2)) AS total_payment_amount
FROM dbo.vw_payment_summary
WHERE payment_count > 1
ORDER BY payment_count DESC;


-- 20. Orders without payment records

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    CAST(o.order_sales AS DECIMAL(18,2)) AS order_sales
FROM dbo.vw_order_sales AS o
LEFT JOIN dbo.vw_payment_summary AS p
    ON o.order_id = p.order_id
WHERE p.order_id IS NULL
ORDER BY o.order_id;


/*
============================================================
08 - ADVANCED SQL ANALYSIS
============================================================
*/

-- 21. Cumulative revenue over time

WITH MonthlySales AS
(
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(order_sales) AS monthly_sales
    FROM dbo.vw_order_sales
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)
SELECT
    order_year,
    order_month,
    CAST(monthly_sales AS DECIMAL(18,2)) AS monthly_sales,
    CAST(
        SUM(monthly_sales) OVER
        (
            ORDER BY order_year, order_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
        AS DECIMAL(18,2)
    ) AS cumulative_sales
FROM MonthlySales
ORDER BY order_year, order_month;


-- 22. Customer revenue ranking

SELECT
    customer_id,
    customer_name,
    total_orders,
    CAST(total_sales AS DECIMAL(18,2)) AS total_sales,
    RANK() OVER
    (
        ORDER BY total_sales DESC
    ) AS revenue_rank
FROM dbo.vw_customer_sales
ORDER BY revenue_rank;


-- 23. Customer revenue deciles

WITH RankedCustomers AS
(
    SELECT
        customer_id,
        customer_name,
        total_sales,
        NTILE(10) OVER
        (
            ORDER BY total_sales DESC
        ) AS customer_decile
    FROM dbo.vw_customer_sales
)
SELECT
    customer_decile,
    COUNT(*) AS customer_count,
    CAST(SUM(total_sales) AS DECIMAL(18,2)) AS total_sales,
    CAST(
        SUM(total_sales) * 100.0 /
        SUM(SUM(total_sales)) OVER ()
        AS DECIMAL(10,2)
    ) AS revenue_contribution_pct
FROM RankedCustomers
GROUP BY customer_decile
ORDER BY customer_decile;