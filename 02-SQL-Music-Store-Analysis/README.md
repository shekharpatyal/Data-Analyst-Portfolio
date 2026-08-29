# Music Store SQL Analysis

## Problem
Analyze sales data for a digital music store to identify top customers, best-selling genres, and employee performance.

## Database
Chinook Database (MySQL) — 11 tables

## Tools
MySQL, SQL (JOINs, CTEs, Window Functions)

## Key Findings

| Query | Finding |
|-------|---------|
| Top Customer | Helena Holý — $49.62 |
| Best Genre | Rock — 835 tracks sold |
| Top Country | USA |
| Top Employee | Jane Peacock — 35.77% of total sales |
| Avg Spend | $39.47 per customer |

## Concepts Used
- JOINs (multiple tables)
- CTEs (WITH clause)
- Window Functions (RANK, LAG, NTILE)
- CASE statements

## Files
- `musicstoreproject.sql` — all 10 queries
- `screenshots/` — query outputs
## Query Outputs

### Top 10 Customers
![Top Customers](top_customers.png)

### Best Selling Genres
![Best Genres](best_genres.png)

### Employee Sales Performance
![Employee Ranking](employee_ranking.png)

### Customer Segments
![Customer Segments](customer_segments.png)
