-- TASK 6: Product Review and Rating Management System
-- Run after Tasks 2-5. Uses the existing Product table.
USE emart;

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

CREATE TABLE IF NOT EXISTS Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating TINYINT NOT NULL,
    review_text VARCHAR(500),
    review_date DATE NOT NULL,
    CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO Review (customer_id, product_id, rating, review_text, review_date) VALUES
(1, 1, 5, 'Excellent performance and quality.', '2026-09-01'),
(2, 1, 4, 'Good product for the price.', '2026-09-03'),
(3, 2, 5, 'Very useful and easy to use.', '2026-09-05'),
(4, 3, 4, 'Comfortable material.', '2026-09-06'),
(5, 4, 3, 'Average quality.', '2026-09-08'),
(1, 5, 5, 'Good quality rice.', '2026-09-10');

-- Retrieve product review details.
SELECT r.review_id, c.customer_name, p.product_name, r.rating,
       r.review_text, r.review_date
FROM Review r
JOIN Customer c ON c.customer_id = r.customer_id
JOIN Product p ON p.product_id = r.product_id
ORDER BY r.review_date DESC;

-- Average rating and review count for every product.
SELECT p.product_id, p.product_name,
       ROUND(AVG(r.rating), 2) AS average_rating,
       COUNT(r.review_id) AS total_reviews
FROM Product p
LEFT JOIN Review r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC;

-- Highly rated products (average rating >= 4).
SELECT p.product_name, ROUND(AVG(r.rating), 2) AS average_rating
FROM Product p
JOIN Review r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) >= 4
ORDER BY average_rating DESC;
