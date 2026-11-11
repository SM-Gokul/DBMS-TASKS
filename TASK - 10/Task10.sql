-- TASK 10: Advanced SQL Query System
USE emart;

SELECT product_id, product_name, price
FROM Product
WHERE price > (SELECT AVG(price) FROM Product)
ORDER BY price DESC;

SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_purchase
FROM Customer c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(total_amount) AS customer_total
        FROM Orders
        GROUP BY customer_id
    ) AS customer_totals
);

SELECT c.customer_name, SUM(o.total_amount) AS total_purchase
FROM Customer c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(customer_total)
    FROM (
        SELECT SUM(total_amount) AS customer_total
        FROM Orders
        GROUP BY customer_id
    ) AS totals
);

SELECT p.product_id, p.product_name
FROM Product p
WHERE NOT EXISTS (
    SELECT 1 FROM Order_Details od WHERE od.product_id = p.product_id
);

SELECT p.product_id, p.product_name, SUM(od.quantity) AS units_sold
FROM Product p
JOIN Order_Details od ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(od.quantity) > (
    SELECT AVG(product_quantity)
    FROM (
        SELECT SUM(quantity) AS product_quantity
        FROM Order_Details
        GROUP BY product_id
    ) AS product_sales
);

SELECT c.customer_name, o.order_id, o.order_date, o.total_amount,
       pay.payment_mode, pay.payment_date
FROM Customer c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN Payment pay ON pay.order_id = o.order_id
WHERE pay.status = 'Successful'
  AND o.total_amount >= (SELECT AVG(total_amount) FROM Orders)
ORDER BY o.total_amount DESC;
