-- TASK 12: Transaction Management System
USE emart;

DROP PROCEDURE IF EXISTS sp_transaction_demo;
DELIMITER //
CREATE PROCEDURE sp_transaction_demo(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_stock INT DEFAULT NULL;
    DECLARE v_price DECIMAL(10,2) DEFAULT NULL;
    DECLARE v_order_id INT;

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
    FROM Product WHERE product_id = p_product_id FOR UPDATE;

    IF v_stock IS NULL OR v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found or insufficient stock';
    END IF;

    INSERT INTO Orders(customer_id, order_date, total_amount)
    VALUES(p_customer_id, CURDATE(), p_quantity * v_price);
    SET v_order_id = LAST_INSERT_ID();

    INSERT INTO Order_Details(order_id, product_id, quantity, price)
    VALUES(v_order_id, p_product_id, p_quantity, v_price);

    INSERT INTO Payment(order_id, payment_mode, payment_date, amount, status)
    VALUES(v_order_id, 'UPI', CURDATE(), p_quantity * v_price, 'Successful');

    UPDATE Product SET stock = stock - p_quantity
    WHERE product_id = p_product_id;

    COMMIT;
    SELECT v_order_id AS committed_order_id;
END //
DELIMITER ;

-- COMMIT demonstration: creates a real order and updates stock/payment together.
-- Call only when you want to insert a new sample order:
-- CALL sp_transaction_demo(1, 2, 1);

START TRANSACTION;
UPDATE Product SET stock = stock + 100 WHERE product_id = 2;
SELECT product_id, product_name, stock FROM Product WHERE product_id = 2;
ROLLBACK;
SELECT product_id, product_name, stock FROM Product WHERE product_id = 2;

-- ACID:
-- Atomicity: order, order item, payment and stock update commit together.
-- Consistency: constraints and stock validation maintain valid data.
-- Isolation: SELECT ... FOR UPDATE locks the product row.
-- Durability: COMMIT makes the transaction permanent.
