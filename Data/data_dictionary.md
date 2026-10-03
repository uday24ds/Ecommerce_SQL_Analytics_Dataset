# E-Commerce SQL Analytics — Data Dictionary

## Tables
- customers_raw: customer master data
- products_raw: product master data
- orders_raw: order header transactions
- order_items_raw: products within each order
- payments_raw: payment attempts and outcomes

## Grain
- customers_raw: one row per customer
- products_raw: one row per product
- orders_raw: one row per order
- order_items_raw: one row per product line within an order
- payments_raw: one row per payment attempt

## Important business rule
Recognized sales revenue will be based on successfully completed orders.
