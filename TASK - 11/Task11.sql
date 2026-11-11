-- TASK 11: Database Automation using Views and Procedures
USE emart;

CREATE OR REPLACE VIEW vw_order_details AS
SELECT o.order_id, o.order_date, c.customer_id, c.customer_name,
       p.product_id, p.product_name, od.quantity, od.price,
       (od.quantity * od.price) AS line_total, o.total_amount
FROM Orders o
JOIN Customer c ON c.customer_id = o.customer_id
JOIN Order_Details od ON od.order_id = o.order_id
JOIN Product p ON p.product_id = od.product_id;

CREATE OR REPLACE VIEW vw_customer_sales AS
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM Customer c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name;

DROP FUNCTION IF EXISTS fn_line_total;
DELIMITER //
CREATE FUNCTION fn_line_total(p_quantity INT, p_unit_price DECIMAL(10,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN p_quantity * p_unit_price;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_place_order;
DELIMITER //
CREATE PROCEDURE sp_place_order(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    OUT p_new_order_id INT
)
BEGIN
    DECLARE v_stock INT DEFAULT NULL;
    DECLARE v_price DECIMAL(10,2) DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    START TRANSACTION;
    SELECT stock, price INTO v_stock, v_price
    FROM Product
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_stock IS NULL OR v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found or insufficient stock';
    END IF;

    INSERT INTO Orders (customer_id, order_date, total_amount)
    VALUES (p_customer_id, CURDATE(), p_quantity * v_price);
    SET p_new_order_id = LAST_INSERT_ID();

    INSERT INTO Order_Details (order_id, product_id, quantity, price)
    VALUES (p_new_order_id, p_product_id, p_quantity, v_price);

    UPDATE Product SET stock = stock - p_quantity
    WHERE product_id = p_product_id;
    COMMIT;
END //
DELIMITER ;

SELECT * FROM vw_order_details;
SELECT * FROM vw_customer_sales;
SELECT fn_line_total(2, 499.00) AS calculated_line_total;

-- Uncomment to place an actual order and decrease stock:
-- CALL sp_place_order(1, 3, 1, @new_order_id);
-- SELECT @new_order_id AS created_order_id;
