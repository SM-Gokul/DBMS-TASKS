-- TASK 14: Business Intelligence and AI Data Preparation
USE emart;

SELECT p.product_id, p.product_name,
       SUM(od.quantity) AS units_sold,
       SUM(od.quantity * od.price) AS revenue
FROM Product p
JOIN Order_Details od ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC;

SELECT product_id, product_name, revenue,
       RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM (
    SELECT p.product_id, p.product_name,
           COALESCE(SUM(od.quantity * od.price), 0) AS revenue
    FROM Product p
    LEFT JOIN Order_Details od ON od.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
) AS product_revenue;

SELECT customer_id, customer_name, order_id, order_date, total_amount,
       ROW_NUMBER() OVER (
           PARTITION BY customer_id
           ORDER BY order_date DESC, order_id DESC
       ) AS order_number
FROM (
    SELECT c.customer_id, c.customer_name, o.order_id,
           o.order_date, o.total_amount
    FROM Customer c
    JOIN Orders o ON o.customer_id = c.customer_id
) AS customer_orders;

SELECT customer_id, customer_name, total_spent,
       CASE
           WHEN total_spent >= 50000 THEN 'Premium'
           WHEN total_spent >= 10000 THEN 'Regular'
           ELSE 'Basic'
       END AS customer_segment
FROM (
    SELECT c.customer_id, c.customer_name,
           COALESCE(SUM(o.total_amount), 0) AS total_spent
    FROM Customer c
    LEFT JOIN Orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_summary
ORDER BY total_spent DESC;

SELECT c.customer_id,
       COALESCE(os.order_count, 0) AS order_count,
       COALESCE(os.lifetime_value, 0) AS lifetime_value,
       COALESCE(os.average_order_value, 0) AS average_order_value,
       COALESCE(DATEDIFF(CURDATE(), os.last_order_date), 9999) AS days_since_last_order,
       COALESCE(items.total_items_purchased, 0) AS total_items_purchased
FROM Customer c
LEFT JOIN (
    SELECT customer_id, COUNT(*) AS order_count,
           SUM(total_amount) AS lifetime_value,
           AVG(total_amount) AS average_order_value,
           MAX(order_date) AS last_order_date
    FROM Orders
    GROUP BY customer_id
) AS os ON os.customer_id = c.customer_id
LEFT JOIN (
    SELECT o.customer_id, SUM(od.quantity) AS total_items_purchased
    FROM Orders o
    JOIN Order_Details od ON od.order_id = o.order_id
    GROUP BY o.customer_id
) AS items ON items.customer_id = c.customer_id;

SELECT product_id, COUNT(*) AS review_count,
       AVG(rating) AS average_rating,
       SUM(CASE WHEN rating >= 4 THEN 1 ELSE 0 END) AS positive_review_count
FROM Review
GROUP BY product_id;
