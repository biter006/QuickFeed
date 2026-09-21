-- Bài thực hành View, Index và Stored Procedure
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

CREATE TABLE Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(12, 2) NOT NULL,
    productAmount INT NOT NULL DEFAULT 0,
    productDescription TEXT,
    productStatus BIT NOT NULL DEFAULT 1
);

INSERT INTO Products (
    productCode, productName, productPrice, productAmount,
    productDescription, productStatus
) VALUES
    ('P001', 'Laptop Dell', 18000000.00, 10, 'Laptop van phong', 1),
    ('P002', 'Chuot Logitech', 450000.00, 50, 'Chuot khong day', 1),
    ('P003', 'Ban phim Keychron', 2100000.00, 20, 'Ban phim co', 1),
    ('P004', 'Man hinh LG', 5200000.00, 15, 'Man hinh 24 inch', 0),
    ('P005', 'Tai nghe Sony', 1500000.00, 30, 'Tai nghe chong on', 1);

-- INDEX: So sánh kế hoạch trước và sau khi tạo Unique Index theo productCode.
EXPLAIN
SELECT *
FROM Products
WHERE productCode = 'P003';

CREATE UNIQUE INDEX idx_product_code
ON Products(productCode);

EXPLAIN
SELECT *
FROM Products
WHERE productCode = 'P003';

-- Composite Index theo productName và productPrice.
EXPLAIN
SELECT *
FROM Products
WHERE productName = 'Laptop Dell'
  AND productPrice = 18000000.00;

CREATE INDEX idx_product_name_price
ON Products(productName, productPrice);

EXPLAIN
SELECT *
FROM Products
WHERE productName = 'Laptop Dell'
  AND productPrice = 18000000.00;

-- VIEW: tạo view lấy các trường yêu cầu.
CREATE VIEW product_views AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

SELECT *
FROM product_views;

-- Sửa view: chỉ hiển thị sản phẩm đang hoạt động.
CREATE OR REPLACE VIEW product_views AS
SELECT productCode, productName, productPrice, productStatus
FROM Products
WHERE productStatus = 1;

SELECT *
FROM product_views;

-- Xóa view sau khi đã kiểm tra kết quả.
DROP VIEW product_views;

-- STORED PROCEDURE: tạo các thủ tục CRUD cho Products.
DELIMITER //

DROP PROCEDURE IF EXISTS getAllProducts //
CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT * FROM Products;
END //

DROP PROCEDURE IF EXISTS addProduct //
CREATE PROCEDURE addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12, 2),
    IN p_amount INT,
    IN p_description TEXT,
    IN p_status BIT
)
BEGIN
    INSERT INTO Products (
        productCode, productName, productPrice, productAmount,
        productDescription, productStatus
    ) VALUES (
        p_code, p_name, p_price, p_amount, p_description, p_status
    );
END //

DROP PROCEDURE IF EXISTS updateProductById //
CREATE PROCEDURE updateProductById(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12, 2),
    IN p_amount INT,
    IN p_description TEXT,
    IN p_status BIT
)
BEGIN
    UPDATE Products
    SET
        productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_description,
        productStatus = p_status
    WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS deleteProductById //
CREATE PROCEDURE deleteProductById(IN p_id INT)
BEGIN
    DELETE FROM Products
    WHERE id = p_id;
END //

DELIMITER ;

-- Gọi procedure lấy toàn bộ sản phẩm.
CALL getAllProducts();

-- Ví dụ gọi các procedure còn lại:
-- CALL addProduct('P006', 'Webcam Logitech', 900000.00, 12, 'Webcam full HD', 1);
-- CALL updateProductById(1, 'P001', 'Laptop Dell Inspiron', 18500000.00, 8, 'Laptop van phong moi', 1);
-- CALL deleteProductById(5);
