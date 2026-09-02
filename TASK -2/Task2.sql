USE emart;
USE emart;

SHOW TABLES;
INSERT INTO Category (category_name, description)
VALUES
('Electronics', 'Electronic products'),
('Clothing', 'Clothes and fashion products'),
('Grocery', 'Daily grocery products');
SELECT * FROM Category;
INSERT INTO Product
(product_name, category_id, price, stock)
VALUES
('Laptop', 1, 55000.00, 10),
('Mobile Phone', 1, 20000.00, 15),
('T-Shirt', 2, 799.00, 25),
('Jeans', 2, 1499.00, 20),
('Rice', 3, 1200.00, 50);
SELECT * FROM Product;
DELETE FROM Product
WHERE product_id > 5;
SELECT * FROM Product;
UPDATE Product
SET price = 58000.00
WHERE product_id = 1;
SELECT
    Category.category_name,
    Product.product_name,
    Product.price,
    Product.stock
FROM Category
JOIN Product
ON Category.category_id = Product.category_id
ORDER BY Category.category_name;
