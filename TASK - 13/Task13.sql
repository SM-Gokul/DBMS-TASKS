-- TASK 13: Database Security and Performance Optimization
USE emart;

CREATE ROLE IF NOT EXISTS 'emart_readonly';
GRANT SELECT ON emart.* TO 'emart_readonly';

-- Sample database user. Change this example password before real deployment.
CREATE USER IF NOT EXISTS 'emart_analyst'@'localhost'
IDENTIFIED BY 'ChangeMe_123!';
GRANT 'emart_readonly' TO 'emart_analyst'@'localhost';
SET DEFAULT ROLE 'emart_readonly' TO 'emart_analyst'@'localhost';

-- REVOKE demonstration (uncomment to remove read permission).
-- REVOKE SELECT ON emart.* FROM 'emart_readonly';

CREATE INDEX idx_product_category ON Product(category_id);
CREATE INDEX idx_product_price ON Product(price);
CREATE INDEX idx_orders_customer_date ON Orders(customer_id, order_date);
CREATE INDEX idx_order_details_product ON Order_Details(product_id);
CREATE INDEX idx_payment_order_status ON Payment(order_id, status);
CREATE INDEX idx_review_product_rating ON Review(product_id, rating);

EXPLAIN
SELECT product_id, product_name, price
FROM Product
WHERE price BETWEEN 1000 AND 30000;

EXPLAIN
SELECT o.order_id, c.customer_name, o.total_amount
FROM Orders o
JOIN Customer c ON c.customer_id = o.customer_id
WHERE o.customer_id = 1
ORDER BY o.order_date;

ANALYZE TABLE Product, Orders, Order_Details, Payment, Review;

-- CREATE USER and GRANT require administrative privileges.
