USE emart;

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_mode VARCHAR(30),
    payment_date DATE,
    amount DECIMAL(10,2),
    status VARCHAR(20),

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);


INSERT INTO Payment
(order_id, payment_mode, payment_date, amount, status)
VALUES
(1, 'UPI', '2026-08-20', 59000.00, 'Successful'),
(2, 'Credit Card', '2026-08-21', 1499.00, 'Successful'),
(3, 'Cash', '2026-08-22', 1200.00, 'Failed');


SELECT * FROM Payment;


SELECT
    payment_mode,
    COUNT(*) AS total_transactions
FROM Payment
GROUP BY payment_mode;

SELECT
    Payment.payment_id,
    Payment.order_id,
    Payment.payment_mode,
    Payment.payment_date,
    Payment.amount,
    Payment.status
FROM Payment
ORDER BY Payment.payment_date;
SELECT
    payment_mode,
    COUNT(*) AS total_transactions
FROM Payment
GROUP BY payment_mode;
