# E-Commerce Sales Analysis

## 1. Project Overview

This project focuses on analysing an e-commerce business dataset using PostgreSQL.

The analysis covers sales trends, customer purchasing behaviour, product performance, seller performance, payment methods, delivery operations and customer reviews.

The goal was to explore the data, understand relationships between different tables, answer practical business questions and identify useful patterns from the results.

## 2. Dataset Source

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Source:** [Kaggle – Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Database:** PostgreSQL  
**Domain:** E-Commerce  
**Data Period:** 2016–2018

The dataset contains historical order-level information from Olist, including customer details, products, sellers, payments, reviews and delivery information.

The original CSV files are included in this repository for reference and to make the analysis reproducible.

## 3. Repository Structure

```text
ecommerce-sales-analysis/
│
├── Dataset/
│   ├── olist_customers_dataset.csv
│   ├── olist_geolocation_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_orders_dataset.csv
│   ├── olist_products_dataset.csv
│   ├── olist_sellers_dataset.csv
│   └── product_category_name_translation.csv
│
├── SQL/
│   ├── 01_Data_Exploration.sql
│   ├── 02_Data_Quality_Checks.sql
│   ├── 03_Business_Analysis.sql
│   └── 04_Advanced_Analysis.sql
│
├── Insights/
│   └── Key_Findings.md
│
└── README.md
```

## 4. Database Setup

The analysis was performed using PostgreSQL.

To explore the project:

1. Download or clone this repository.
2. Download the CSV files from the `Dataset` folder.
3. Create a PostgreSQL database named `ecommerce_analytics`.
4. Import the CSV files into PostgreSQL as separate tables.
5. Check the table structures and relationships.
6. Open the SQL files and execute the queries in PostgreSQL.

**Database Name:** `ecommerce_analytics`

## 5. Database Tables

The project uses nine tables:

| Table | Description |
|---|---|
| `customers` | Customer records and location details |
| `orders` | Order dates, status and delivery information |
| `order_items` | Products, sellers, prices and freight |
| `order_payments` | Payment methods and payment values |
| `order_reviews` | Customer review scores and comments |
| `products` | Product details and categories |
| `sellers` | Seller information and locations |
| `geolocation` | Geographic coordinates |
| `category_translation` | Portuguese-to-English category names |

## 6. Analysis Approach

The project was completed in the following stages:

**Step 1 – Data Exploration**

- Reviewed the available tables and columns.
- Examined record counts and data types.
- Identified important keys and relationships between tables.

**Step 2 – Data Quality and Validation**

- Investigated missing values and duplicate records.
- Checked how customer identifiers work across orders.
- Considered the impact of missing months on monthly comparisons.
- Reviewed table relationships to avoid misleading aggregations.

**Step 3 – Business Analysis**

- Wrote SQL queries to answer practical e-commerce business questions.
- Used joins and aggregate functions to combine and summarise data.
- Compared sales, customers, products, sellers and delivery performance.

**Step 4 – Advanced SQL Analysis**

- Used CTEs and subqueries to structure complex analysis.
- Applied window functions such as `ROW_NUMBER()`, `DENSE_RANK()` and `LAG()`.
- Analysed customer purchase patterns and seller rankings.

**Step 5 – Findings and Interpretation**

- Reviewed query results.
- Identified important business patterns.
- Documented findings and possible areas for business improvement.

## 7. Business Questions Explored

### Sales Analysis
- How do order volumes change over time?
- Which product categories generate the highest sales?
- Which payment method contributes the most payment value?
- Which states generate the highest sales?
- How does average order value vary across states?
- How does monthly revenue change over time?

### Customer Analysis
- How many customers place repeat orders?
- Who are the highest-spending customers?
- How frequently do customers purchase?
- What percentage of customers place more than one delivered order?

### Delivery and Customer Satisfaction
- What is the average delivery time?
- What percentage of delivered orders arrive late?
- How are customer review scores distributed?
- How do review scores differ between on-time and late deliveries?

### Seller and Product Analysis
- Which sellers generate the highest sales?
- Who are the top sellers within each state?
- Which products generate the highest revenue in each category?
- How do seller delivery performance and customer ratings vary?

## 8. Key Findings

The following findings are based on the SQL analysis performed on the dataset.

| Area | Finding |
|---|---|
| Payment Analysis | Credit cards generated the highest recorded payment value: approximately R$12.54 million. |
| State-wise Sales | São Paulo (SP) recorded the highest item sales revenue, approximately R$5.20 million. |
| Delivery Performance | Average delivery time for delivered orders was approximately 12.56 days. |
| Late Deliveries | Approximately 8.11% of the delivered orders analysed were delivered after the estimated date. |
| Customer Reviews | Approximately 77.07% of recorded reviews had a score of 4 or 5. |
| Repeat Customers | Approximately 3% of customers had more than one delivered order. |
| Monthly Revenue | November 2017 recorded the highest monthly item sales revenue in the analysed period, approximately R$1.01 million. |

These findings highlight differences in sales performance, customer purchasing behaviour and delivery operations across the dataset.

## 9. SQL Concepts Used

- SELECT, WHERE, ORDER BY and LIMIT
- GROUP BY and aggregate functions
- INNER JOIN and multi-table joins
- CASE WHEN and FILTER
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- DENSE_RANK()
- LAG()
- Date and time calculations
- NULL handling
- Data validation and aggregation

## 10. Business Takeaways

The analysis highlights a few areas worth further investigation:

- **Customer Retention:** The low repeat-customer percentage suggests an opportunity to investigate loyalty programmes and targeted post-purchase offers.
- **Delivery Operations:** Late deliveries are associated with lower average review scores, making delivery performance an important area to monitor.
- **Regional Performance:** São Paulo is the strongest market in both order volume and item sales revenue.
- **Product Performance:** Category-level product rankings can help identify products that deserve closer attention in inventory and promotional planning.
- **Seller Performance:** Comparing seller-level sales and delivery metrics can help identify operational differences between sellers.

## 11. Important Notes and Limitations

- The dataset is historical public data, not live company data.
- Sales calculations using `order_items.price` represent item sales value and exclude freight charges.
- Sales revenue is not the same as profit. Product costs and other expenses are not included in this calculation.
- Repeat-customer percentage is based on delivered orders. It is not a cohort-based retention rate.
- Delivery and review relationships show an association, not proof of causation.
- Missing or incomplete periods should be considered when interpreting monthly trends.

## 12. Project Outcome

This project provided practical experience in working with relational e-commerce data, writing PostgreSQL queries and interpreting query results in a business context.

It demonstrates the use of SQL for data exploration, multi-table analysis, business reporting and advanced analytical queries.
---

**Tools:** PostgreSQL | SQL | pgAdmin / psql  
**Dataset Source:** [Kaggle – Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

Note: The geolocation dataset is provided as a ZIP file. Extract it before importing into PostgreSQL.
