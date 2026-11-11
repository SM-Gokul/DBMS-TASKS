-- TASK 8: Database Relationship Analysis using Joins
USE emart;

INSERT IGNORE INTO Customer (customer_id, customer_name, email, phone, city) VALUES
(1, 'Arun Kumar', 'arun@example.com', '9000000001', 'Chennai'),
(2, 'Priya S', 'priya@example.com', '9000000002', 'Erode'),
(3, 'Rahul M', 'rahul@example.com', '9000000003', 'Coimbatore');

SELECT o.order_id, o.order_date, c.customer_name,
       p.product_name, od.quantity, od.price, o.total_amount
FROM Orders o
INNER JOIN Customer c ON c.customer_id = o.customer_id
INNER JOIN Order_Details od ON od.order_id = o.order_id
INNER JOIN Product p ON p.product_id = od.product_id
ORDER BY o.order_date;

SELECT c.customer_id, c.customer_name, o.order_id, o.order_date, o.total_amount
FROM Customer c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id;

SELECT p.product_id, p.product_name, od.order_id, od.quantity
FROM Order_Details od
RIGHT JOIN Product p ON p.product_id = od.product_id
ORDER BY p.product_id;

SELECT c.customer_name, o.order_id, o.order_date,
       p.product_name, od.quantity, (od.quantity * od.price) AS line_total
FROM Customer c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN Order_Details od ON od.order_id = o.order_id
JOIN Product p ON p.product_id = od.product_id
ORDER BY c.customer_name, o.order_date DESC;

SELECT c.customer_name, o.order_id, o.order_date, p.product_name,
       od.quantity, od.price, pay.payment_mode, pay.status AS payment_status
FROM Customer c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN Order_Details od ON od.order_id = o.order_id
JOIN Product p ON p.product_id = od.product_id
LEFT JOIN Payment pay ON pay.order_id = o.order_id
ORDER BY o.order_id;
