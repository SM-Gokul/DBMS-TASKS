-- TASK 15: Industry Capstone Project - E-Commerce Intelligence Platform
-- Run Tasks 2, 3, 4, 5 and 6 before this integrated capstone.
USE emart;

-- Core normalized relationships:
-- Category 1:M Product
-- Seller 1:M Inventory; Product 1:M Inventory
-- Customer 1:M Orders; Orders 1:M Order_Details
-- Product 1:M Order_Details; Orders 1:M Payment
-- Customer 1:M Review; Product 1:M Review

CREATE TABLE IF NOT EXISTS Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    city VARCHAR(60)
);

INSERT IGNORE INTO Customer (customer_id, customer_name, email, phone, city) VALUES
(1, 'Arun Kumar', 'arun@example.com', '9000000001', 'Chennai'),
(2, 'Priya S', 'priya@example.com', '9000000002', 'Erode'),
(3, 'Rahul M', 'rahul@example.com', '9000000003', 'Coimbatore'),
(4, 'Meena R', 'meena@example.com', '9000000004', 'Madurai'),
(5, 'Karthik V', 'karthik@example.com', '9000000005', 'Salem');

CREATE INDEX idx_cap_product_category_price ON Product(category_id, price);
CREATE INDEX idx_cap_orders_customer_date ON Orders(customer_id, order_date);
CREATE INDEX idx_cap_order_details_order_product ON Order_Details(order_id, product_id);
CREATE INDEX idx_cap_payment_status_date ON Payment(status, payment_date);

CREATE TABLE IF NOT EXISTS Order_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    old_total DECIMAL(10,2),
    new_total DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_note VARCHAR(100)
);

DROP TRIGGER IF EXISTS trg_orders_after_update_audit;
DELIMITER //
CREATE TRIGGER trg_orders_after_update_audit
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF OLD.total_amount <> NEW.total_amount THEN
        INSERT INTO Order_Audit (order_id, old_total, new_total, action_note)
        VALUES (NEW.order_id, OLD.total_amount, NEW.total_amount, 'Order total updated');
    END IF;
END //
DELIMITER ;

SELECT c.customer_name, o.order_id, o.order_date,
       p.product_name, od.quantity, od.price,
       (od.quantity * od.price) AS line_total,
       pay.payment_mode, pay.status AS payment_status
FROM Customer c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN Order_Details od ON od.order_id = o.order_id
JOIN Product p ON p.product_id = od.product_id
LEFT JOIN Payment pay ON pay.order_id = o.order_id
ORDER BY o.order_date DESC, o.order_id;

SELECT cat.category_name,
       SUM(od.quantity) AS units_sold,
       SUM(od.quantity * od.price) AS revenue
FROM Category cat
JOIN Product p ON p.category_id = cat.category_id
JOIN Order_Details od ON od.product_id = p.product_id
GROUP BY cat.category_id, cat.category_name
ORDER BY revenue DESC;

SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS order_count,
       COALESCE(SUM(o.total_amount), 0) AS lifetime_value
FROM Customer c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC;

SHOW FULL TABLES IN emart;
SHOW INDEX FROM Product;
SELECT * FROM Order_Audit ORDER BY changed_at DESC;

-- Trigger test (uncomment to update order 1 and create an audit record):
-- UPDATE Orders SET total_amount = total_amount + 1 WHERE order_id = 1;
-- SELECT * FROM Order_Audit WHERE order_id = 1;
