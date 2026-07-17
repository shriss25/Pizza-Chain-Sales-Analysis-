# Pizza Sales Analysis

## Overview
This project analyzes a full year (2015) of pizza sales data — 21,350 orders and 48,620 order line items across 91 pizza SKUs — using SQL for analysis and Excel for interactive reporting. It answers core business questions around revenue, product performance, and order timing, and packages the results into a KPI dashboard.

## Dataset
Four relational tables, joined on `order_id` and `pizza_id` / `pizza_type_id`:
| Table | Rows | Description |
|---|---|---|
| `orders` | 21,350 | order_id, date, time |
| `order_details` | 48,620 | line items — order_id, pizza_id, quantity |
| `pizzas` | 96 | pizza_id, pizza_type_id, size, price |
| `pizza_types` | 32 | pizza_type_id, name, category, ingredients |

![Database Schema](screenshots/schema.png)

## Tools Used
- SQLite (query development & validation)
- SQL (joins, aggregates, window functions)
- Microsoft Excel (formulas, PivotTables, charts, dashboard)

## KPIs
| Metric | Value |
|---|---|
| Total Revenue | $817,860.05 |
| Total Orders | 21,350 |
| Total Pizzas Sold | 49,574 |
| Average Order Value | $38.31 |
| Average Pizzas per Order | 2.32 |

## Dashboard
![Pizza Sales Dashboard](screenshots/dashboard.png)

The Excel dashboard (`dashboard/Pizza Dashboard.xlsx`) includes:
- 5 KPI cards (Total Revenue, Total Orders, Total Pizzas Sold, Avg Order Value, Avg Pizzas/Order) — all formula-driven off the raw data, not hardcoded
- Revenue by Category (Pie), Revenue by Size (Doughnut), Monthly Revenue (Line), Top 10 Pizzas (Horizontal Bar), Orders by Hour (Column), Orders by Day (Bar)
- A raw `SalesData` Excel Table (48,620 rows) ready for PivotTables and slicers on Month, Category, and Size

## Key Insights
- **Classic** pizzas sold the most units (14,888) and generated the highest revenue ($220,053), while **Chicken** pizzas had the highest revenue per pizza sold despite the fewest units moved.
- **Large (L)** pizzas drove the most revenue ($375,319 — 46% of total), while **The Thai Chicken Pizza** was the top earner within the Chicken category ($43,434).
- Orders peak at **lunch (12–1 PM)** and again at **dinner (5–7 PM)**, with very little volume before 11 AM or after 10 PM.
- **Friday** is the busiest day of the week (3,538 orders); **Sunday** is the quietest (2,624 orders).
- **Weekdays** account for 73% of total revenue ($595,474) versus 27% on weekends ($222,386) — driven simply by having 5 weekdays vs 2 weekend days, not by higher weekend demand.

## Project Structure
```
Pizza-Sales-Analysis/
├── data/                  Raw source CSVs (orders, order_details, pizzas, pizza_types)
├── sql/PizzaSales.sql     20 SQL queries: KPIs, product, time & revenue analysis
├── results/               CSV export of every query's output (Phase 2)
├── dashboard/             Pizza Dashboard.xlsx — KPI cards, charts, raw data table
├── screenshots/           schema.png, sql1.png, sql2.png, dashboard.png
└── README.md
```

## Skills Demonstrated
- SQL JOINs across a 4-table relational schema
- Aggregate functions (SUM, COUNT, AVG) and window functions (RANK)
- KPI reporting and percentage-of-total analysis
- Excel formulas (SUMIFS) driving live KPI cards and charts from raw data
- Dashboard design: KPI cards, chart selection, PivotTable/slicer-ready data
