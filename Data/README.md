# Dataset

This project uses an e-commerce dataset containing customer,
order, product, order-item, and payment information.

## Source Tables

The original dataset was imported into SQL Server as:

- `customers`
- `orders`
- `order_items`
- `payments`
- `products`

## Data Preparation

The raw tables were cleaned and transformed into:

- `customers_clean`
- `orders_clean`
- `order_items_clean`
- `payments_clean`
- `products_clean`

The cleaned tables were then used to build analytical views
and perform business analysis.

## Note

Raw CSV files are not included in this repository.

The repository contains the SQL scripts required to document
the data preparation, analytical views, and business analysis.