-- TASK 7: SQL Query Implementation for E-Commerce Database
USE emart;

SELECT * FROM Product;

SELECT product_id, product_name, price, stock
FROM Product
WHERE price < 2000;

SELECT product_name, price
FROM Product
ORDER BY price DESC;

SELECT DISTINCT c.category_name
FROM Category c
JOIN Product p ON p.category_id = c.category_id;

SELECT p.product_name, c.category_name, p.price, p.stock
FROM Product p
JOIN Category c ON c.category_id = p.category_id
WHERE c.category_name = 'Electronics';

SELECT product_name, price
FROM Product
WHERE price BETWEEN 500 AND 25000
ORDER BY price;

SELECT product_name, stock,
       CASE WHEN stock > 0 THEN 'Available' ELSE 'Out of Stock' END AS availability
FROM Product
WHERE stock > 0;

SELECT customer_id, customer_name, email, phone, city
FROM Customer
WHERE city IN ('Chennai', 'Erode');

SELECT product_name, price, stock
FROM Product
WHERE price >= 1000 AND stock >= 10
ORDER BY price DESC;

SELECT c.category_name,
       COUNT(p.product_id) AS product_count,
       COALESCE(SUM(p.stock), 0) AS total_units,
       COALESCE(SUM(p.price * p.stock), 0) AS inventory_value
FROM Category c
LEFT JOIN Product p ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY inventory_value DESC;
