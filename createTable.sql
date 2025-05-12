CREATE DATABASE InventoryDataBase;
GO

USE InventoryDataBase;
GO

CREATE TABLE items (
    item_id INT PRIMARY KEY IDENTITY(1,1),
    item_name NVARCHAR(100) NOT NULL,
    quantity_in_stock INT NOT NULL CHECK (quantity_in_stock >= 0),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    status NVARCHAR(20) NOT NULL CHECK (status IN ('available', 'sold out', 'low stock'))
);
GO

CREATE TABLE sales (
    sale_id INT PRIMARY KEY IDENTITY(1,1),
    item_id INT NOT NULL,
    quantity_sold INT NOT NULL CHECK (quantity_sold > 0),
    sale_date DATETIME NOT NULL DEFAULT GETDATE(),
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);