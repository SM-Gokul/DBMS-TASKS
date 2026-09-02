USE emart;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
INSERT INTO Orders (customer_id, order_date, total_amount)
VALUES
(1, '2026-08-20', 58000.00),
(2, '2026-08-21', 1499.00),
(3, '2026-08-22', 1200.00);

SELECT * FROM Orders;

INSERT INTO Order_Details (order_id, product_id, quantity, price)
VALUES
(1, 1, 1, 58000.00),
(2, 4, 1, 1499.00),
(3, 5, 1, 1200.00);

SELECT * FROM Order_Details;

UPDATE Orders
SET total_amount = 59000.00
WHERE order_id = 1;

SELECT * FROM Orders;

SELECT
    Orders.order_id,
    Orders.customer_id,
    Orders.order_date,
    Product.product_name,
    Order_Details.quantity,
    Order_Details.price,
    Orders.total_amount
FROM Orders
JOIN Order_Details
    ON Orders.order_id = Order_Details.order_id
JOIN Product
    ON Order_Details.product_id = Product.product_id
ORDER BY Orders.order_date;
