-- ============================================================
--  INVENTORY MANAGEMENT SYSTEM — MySQL Schema
--  COMP344 Lab Project
--  Tables: 12 | Relations: FK, M:M, 1:M | Normal Form: 3NF
-- ============================================================

CREATE DATABASE IF NOT EXISTS inventory_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE inventory_db;

-- ─────────────────────────────────────────
-- 1. ROLES (lookup)
-- ─────────────────────────────────────────
CREATE TABLE Roles (
    role_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_name   VARCHAR(50)  NOT NULL UNIQUE,   -- 'Admin', 'Manager', 'Staff'
    description VARCHAR(255)
);

-- ─────────────────────────────────────────
-- 2. USERS
-- ─────────────────────────────────────────
CREATE TABLE Users (
    user_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id      INT UNSIGNED NOT NULL,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone        VARCHAR(20),
    is_active    BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- ─────────────────────────────────────────
-- 3. CATEGORIES
-- ─────────────────────────────────────────
CREATE TABLE Categories (
    category_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description   VARCHAR(255)
);

-- ─────────────────────────────────────────
-- 4. SUPPLIERS
-- ─────────────────────────────────────────
CREATE TABLE Suppliers (
    supplier_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_name  VARCHAR(150) NOT NULL,
    contact_name  VARCHAR(100),
    email         VARCHAR(150) UNIQUE,
    phone         VARCHAR(20),
    address       VARCHAR(255),
    country       VARCHAR(100),
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE
);

-- ─────────────────────────────────────────
-- 5. WAREHOUSES
-- ─────────────────────────────────────────
CREATE TABLE Warehouses (
    warehouse_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    warehouse_name VARCHAR(150) NOT NULL,
    location       VARCHAR(255),
    manager_id     INT UNSIGNED,
    capacity       INT UNSIGNED,         -- max units
    CONSTRAINT fk_warehouse_manager FOREIGN KEY (manager_id) REFERENCES Users(user_id)
);

-- ─────────────────────────────────────────
-- 6. PRODUCTS
-- ─────────────────────────────────────────
CREATE TABLE Products (
    product_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_id   INT UNSIGNED NOT NULL,
    product_name  VARCHAR(150) NOT NULL,
    SKU           VARCHAR(50)  NOT NULL UNIQUE,   -- barcode / stock-keeping unit
    description   TEXT,
    unit_price    DECIMAL(10,2) NOT NULL,
    reorder_level INT UNSIGNED  NOT NULL DEFAULT 10,  -- alert threshold
    unit          VARCHAR(30)   NOT NULL DEFAULT 'piece',
    is_active     BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- ─────────────────────────────────────────
-- 7. STOCK  (Product ↔ Warehouse = M:M with quantity)
-- ─────────────────────────────────────────
CREATE TABLE Stock (
    stock_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id    INT UNSIGNED NOT NULL,
    warehouse_id  INT UNSIGNED NOT NULL,
    quantity      INT UNSIGNED NOT NULL DEFAULT 0,
    last_updated  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_stock_product   FOREIGN KEY (product_id)   REFERENCES Products(product_id),
    CONSTRAINT fk_stock_warehouse FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    UNIQUE KEY uq_product_warehouse (product_id, warehouse_id)
);

-- ─────────────────────────────────────────
-- 8. PURCHASE ORDERS  (from suppliers)
-- ─────────────────────────────────────────
CREATE TABLE PurchaseOrders (
    po_id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    supplier_id    INT UNSIGNED NOT NULL,
    ordered_by     INT UNSIGNED NOT NULL,   -- User
    warehouse_id   INT UNSIGNED NOT NULL,
    order_date     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expected_date  DATE,
    status         ENUM('Pending','Approved','Received','Cancelled') NOT NULL DEFAULT 'Pending',
    total_amount   DECIMAL(12,2),
    notes          TEXT,
    CONSTRAINT fk_po_supplier  FOREIGN KEY (supplier_id)  REFERENCES Suppliers(supplier_id),
    CONSTRAINT fk_po_user      FOREIGN KEY (ordered_by)   REFERENCES Users(user_id),
    CONSTRAINT fk_po_warehouse FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);

-- ─────────────────────────────────────────
-- 9. PURCHASE ORDER ITEMS
-- ─────────────────────────────────────────
CREATE TABLE PurchaseOrderItems (
    item_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    po_id        INT UNSIGNED   NOT NULL,
    product_id   INT UNSIGNED   NOT NULL,
    quantity     INT UNSIGNED   NOT NULL,
    unit_cost    DECIMAL(10,2)  NOT NULL,
    CONSTRAINT fk_poi_po      FOREIGN KEY (po_id)      REFERENCES PurchaseOrders(po_id),
    CONSTRAINT fk_poi_product FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- ─────────────────────────────────────────
-- 10. STOCK TRANSACTIONS  (audit every movement)
-- ─────────────────────────────────────────
CREATE TABLE StockTransactions (
    txn_id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id     INT UNSIGNED NOT NULL,
    warehouse_id   INT UNSIGNED NOT NULL,
    performed_by   INT UNSIGNED NOT NULL,   -- User
    txn_type       ENUM('IN','OUT','TRANSFER','ADJUSTMENT') NOT NULL,
    quantity       INT          NOT NULL,   -- negative for OUT
    reference_id   INT UNSIGNED,           -- e.g. PO id or sales id
    txn_date       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes          VARCHAR(255),
    CONSTRAINT fk_txn_product   FOREIGN KEY (product_id)   REFERENCES Products(product_id),
    CONSTRAINT fk_txn_warehouse FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    CONSTRAINT fk_txn_user      FOREIGN KEY (performed_by) REFERENCES Users(user_id)
);

-- ─────────────────────────────────────────
-- 11. PRODUCT SUPPLIERS  (M:M — one product, many suppliers)
-- ─────────────────────────────────────────
CREATE TABLE ProductSuppliers (
    product_id    INT UNSIGNED  NOT NULL,
    supplier_id   INT UNSIGNED  NOT NULL,
    supply_price  DECIMAL(10,2) NOT NULL,
    lead_time_days INT UNSIGNED,
    is_preferred  BOOLEAN       NOT NULL DEFAULT FALSE,
    PRIMARY KEY (product_id, supplier_id),
    CONSTRAINT fk_ps_product  FOREIGN KEY (product_id)  REFERENCES Products(product_id),
    CONSTRAINT fk_ps_supplier FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- ─────────────────────────────────────────
-- 12. AUDIT LOG
-- ─────────────────────────────────────────
CREATE TABLE AuditLog (
    log_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id      INT UNSIGNED NOT NULL,
    action       VARCHAR(100) NOT NULL,   -- 'CREATE', 'UPDATE', 'DELETE'
    table_name   VARCHAR(100) NOT NULL,
    record_id    INT UNSIGNED NOT NULL,
    old_value    JSON,
    new_value    JSON,
    logged_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_user FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- ============================================================
--  INDEXES for performance
-- ============================================================
CREATE INDEX idx_products_sku         ON Products(SKU);
CREATE INDEX idx_stock_product        ON Stock(product_id);
CREATE INDEX idx_stock_warehouse      ON Stock(warehouse_id);
CREATE INDEX idx_txn_date             ON StockTransactions(txn_date);
CREATE INDEX idx_po_status            ON PurchaseOrders(status);
CREATE INDEX idx_auditlog_table       ON AuditLog(table_name, record_id);

-- ============================================================
--  VIEWS
-- ============================================================

-- Current stock levels across all warehouses
CREATE VIEW vw_StockSummary AS
SELECT
    p.product_id,
    p.SKU,
    p.product_name,
    c.category_name,
    w.warehouse_name,
    s.quantity,
    p.reorder_level,
    CASE WHEN s.quantity <= p.reorder_level THEN 'LOW STOCK' ELSE 'OK' END AS stock_status
FROM Stock s
JOIN Products   p ON s.product_id   = p.product_id
JOIN Warehouses w ON s.warehouse_id = w.warehouse_id
JOIN Categories c ON p.category_id  = c.category_id;

-- Products with no stock
CREATE VIEW vw_OutOfStock AS
SELECT p.product_id, p.SKU, p.product_name, c.category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.product_id NOT IN (SELECT product_id FROM Stock WHERE quantity > 0)
  AND p.is_active = TRUE;

-- ============================================================
--  STORED PROCEDURE: Transfer stock between warehouses
-- ============================================================
DELIMITER $$
CREATE PROCEDURE sp_TransferStock(
    IN  p_product_id    INT UNSIGNED,
    IN  p_from_wh       INT UNSIGNED,
    IN  p_to_wh         INT UNSIGNED,
    IN  p_qty           INT UNSIGNED,
    IN  p_user_id       INT UNSIGNED,
    OUT p_result        VARCHAR(100)
)
BEGIN
    DECLARE v_available INT DEFAULT 0;

    START TRANSACTION;

    SELECT quantity INTO v_available
    FROM Stock
    WHERE product_id = p_product_id AND warehouse_id = p_from_wh
    FOR UPDATE;

    IF v_available < p_qty THEN
        SET p_result = 'ERROR: Insufficient stock';
        ROLLBACK;
    ELSE
        -- Deduct from source
        UPDATE Stock SET quantity = quantity - p_qty
        WHERE product_id = p_product_id AND warehouse_id = p_from_wh;

        -- Add to destination (insert if not exists)
        INSERT INTO Stock (product_id, warehouse_id, quantity)
        VALUES (p_product_id, p_to_wh, p_qty)
        ON DUPLICATE KEY UPDATE quantity = quantity + p_qty;

        -- Log transaction
        INSERT INTO StockTransactions (product_id, warehouse_id, performed_by, txn_type, quantity, notes)
        VALUES (p_product_id, p_from_wh, p_user_id, 'TRANSFER', -p_qty, CONCAT('Transfer to WH#', p_to_wh));

        INSERT INTO StockTransactions (product_id, warehouse_id, performed_by, txn_type, quantity, notes)
        VALUES (p_product_id, p_to_wh, p_user_id, 'TRANSFER', p_qty, CONCAT('Transfer from WH#', p_from_wh));

        SET p_result = 'OK: Transfer successful';
        COMMIT;
    END IF;
END$$
DELIMITER ;

-- ============================================================
--  TRIGGER: Auto-update AuditLog on Product changes
-- ============================================================
DELIMITER $$
CREATE TRIGGER trg_products_update
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (user_id, action, table_name, record_id, old_value, new_value)
    VALUES (
        1,   -- system user; replace with session user in app
        'UPDATE',
        'Products',
        OLD.product_id,
        JSON_OBJECT('product_name', OLD.product_name, 'unit_price', OLD.unit_price),
        JSON_OBJECT('product_name', NEW.product_name, 'unit_price', NEW.unit_price)
    );
END$$
DELIMITER ;
