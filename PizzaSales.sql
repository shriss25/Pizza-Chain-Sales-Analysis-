/* ============================================================
   PIZZA SALES ANALYSIS
   Database: SQLite
   Tables: orders, order_details, pizzas, pizza_types
   ============================================================ */


/* ============================================================
   SECTION 1: KPIs
   ============================================================ */

-- 1. Total Revenue
SELECT
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;


-- 2. Total Orders
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- 3. Total Pizzas Sold
SELECT
    SUM(quantity) AS total_pizzas_sold
FROM order_details;


-- 4. Average Order Value
SELECT
    ROUND(SUM(od.quantity * p.price) * 1.0 / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id;


-- 5. Average Pizzas per Order
SELECT
    ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_pizzas_per_order
FROM order_details od;


/* ============================================================
   SECTION 2: PRODUCT ANALYSIS
   ============================================================ */

-- 6. Top 10 Best-Selling Pizzas (by quantity sold)
SELECT
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity_sold,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- 7. Bottom 10 Selling Pizzas (by quantity sold)
SELECT
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity_sold,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity_sold ASC
LIMIT 10;


-- 8. Revenue by Category
SELECT
    pt.category,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;


-- 9. Revenue by Size
SELECT
    p.size,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY revenue DESC;


-- 10. Pizzas Sold by Category (quantity, not revenue)
SELECT
    pt.category,
    SUM(od.quantity) AS pizzas_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY pizzas_sold DESC;


-- 11. Best-Selling Pizza per Category (top 1 by revenue, using a window function)
SELECT category, pizza_name, revenue
FROM (
    SELECT
        pt.category,
        pt.name AS pizza_name,
        ROUND(SUM(od.quantity * p.price), 2) AS revenue,
        RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rnk
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
WHERE rnk = 1;


/* ============================================================
   SECTION 3: TIME ANALYSIS
   ============================================================ */

-- 12. Orders by Hour of Day
SELECT
    CAST(strftime('%H', time) AS INTEGER) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;


-- 13. Orders by Day of Week
SELECT
    CASE CAST(strftime('%w', date) AS INTEGER)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_of_week,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY CAST(strftime('%w', date) AS INTEGER)
ORDER BY CAST(strftime('%w', date) AS INTEGER);


-- 14. Monthly Revenue
SELECT
    strftime('%Y-%m', o.date) AS month,
    ROUND(SUM(od.quantity * p.price), 2) AS monthly_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY month
ORDER BY month;


-- 15. Monthly Orders
SELECT
    strftime('%Y-%m', date) AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


-- 16. Weekday vs Weekend Revenue
SELECT
    CASE WHEN CAST(strftime('%w', o.date) AS INTEGER) IN (0, 6)
         THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY day_type;


/* ============================================================
   SECTION 4: CUSTOMER / ORDER INSIGHTS
   ============================================================ */

-- 17. Average Pizzas per Order (distribution check by order size buckets)
SELECT
    pizzas_in_order,
    COUNT(*) AS number_of_orders
FROM (
    SELECT order_id, SUM(quantity) AS pizzas_in_order
    FROM order_details
    GROUP BY order_id
)
GROUP BY pizzas_in_order
ORDER BY pizzas_in_order;


-- 18. Percentage of Revenue by Category
SELECT
    pt.category,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    ROUND(
        SUM(od.quantity * p.price) * 100.0 /
        (SELECT SUM(od2.quantity * p2.price)
         FROM order_details od2 JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id),
        2
    ) AS pct_of_total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY pct_of_total_revenue DESC;


-- 19. Percentage of Revenue by Size
SELECT
    p.size,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    ROUND(
        SUM(od.quantity * p.price) * 100.0 /
        (SELECT SUM(od2.quantity * p2.price)
         FROM order_details od2 JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id),
        2
    ) AS pct_of_total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY pct_of_total_revenue DESC;


-- 20. Highest Revenue-Generating Day (Top 10 single-day totals)
SELECT
    o.date,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders_that_day
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY revenue DESC
LIMIT 10;
