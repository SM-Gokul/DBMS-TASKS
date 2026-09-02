USE emart;

CREATE TABLE Seller (
    seller_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_name VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT,
    product_id INT,
    stock INT,
    status VARCHAR(20),
    FOREIGN KEY (seller_id) REFERENCES Seller(seller_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
INSERT INTO Seller (seller_name, phone, email)
VALUES
('ABC Electronics', '9876543210', 'abc@gmail.com'),
('Fashion Hub', '9876543211', 'fashion@gmail.com'),
('Daily Needs', '9876543212', 'daily@gmail.com');

SELECT * FROM Seller;

INSERT INTO Inventory (seller_id, product_id, stock, status)
VALUES
(1, 1, 10, 'Available'),
(1, 2, 15, 'Available'),
(2, 3, 25, 'Available'),
(2, 4, 0, 'Unavailable'),
(3, 5, 50, 'Available');

SELECT * FROM Inventory;
SELECT
    Seller.seller_name,
    Product.product_name,
    Inventory.stock,
    Inventory.status
FROM Seller
JOIN Inventory
    ON Seller.seller_id = Inventory.seller_id
JOIN Product
    ON Inventory.product_id = Product.product_id;
