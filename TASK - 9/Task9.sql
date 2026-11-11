-- TASK 9: Sales and Customer Analytics System
USE emart;

SELECT COUNT(*) AS total_orders,
       SUM(total_amount) AS total_sales,
       ROUND(AVG(total_amount), 2) AS average_order_value,
       MIN(total_amount) AS minimum_order,
       MAX(total_amount) AS maximum_order
FROM Orders;

SELECT order_date, COUNT(*) AS number_of_orders,
       SUM(total_amount) AS daily_sales
FROM Orders
GROUP BY order_date
ORDER BY order_date;

SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS order_count,
       SUM(o.total_amount) AS purchase_amount
FROM Customer c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY purchase_amount DESC;

SELECT p.product_id, p.product_name,
       SUM(od.quantity) AS units_sold,
       SUM(od.quantity * od.price) AS product_revenue
FROM Product p
JOIN Order_Details od ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC, product_revenue DESC;

SELECT c.category_name,
       SUM(od.quantity) AS units_sold,
       SUM(od.quantity * od.price) AS category_sales,
       ROUND(AVG(od.price), 2) AS average_selling_price
FROM Category c
JOIN Product p ON p.category_id = c.category_id
JOIN Order_Details od ON od.product_id = p.product_id
GROUP BY c.category_id, c.category_name
ORDER BY category_sales DESC;
