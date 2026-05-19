-- ============================================================
--  SEED DATA — Inventory Management System
--  Run AFTER schema.sql
-- ============================================================

USE inventory_db;

-- Roles
INSERT INTO Roles (role_name, description) VALUES
('Admin',   'Full system access'),
('Manager', 'Can approve orders and manage staff'),
('Staff',   'Can view and update stock');

-- Users
INSERT INTO Users (role_id, full_name, email, password_hash, phone) VALUES
(1, 'Alice Admin',    'alice@inv.com',   SHA2('admin123', 256),   '+961-70-000001'),
(2, 'Bob Manager',    'bob@inv.com',     SHA2('manager123', 256), '+961-70-000002'),
(3, 'Carol Staff',    'carol@inv.com',   SHA2('staff123', 256),   '+961-70-000003'),
(3, 'Dave Staff',     'dave@inv.com',    SHA2('staff123', 256),   '+961-70-000004');

-- Categories
INSERT INTO Categories (category_name, description) VALUES
('Networking Equipment', 'Routers, switches, cables'),
('Computing Hardware',   'CPUs, RAM, storage'),
('Peripherals',          'Keyboards, mice, monitors'),
('Software Licenses',    'OS, productivity, security'),
('Cables & Connectors',  'USB, HDMI, fiber');

-- Suppliers
INSERT INTO Suppliers (company_name, contact_name, email, phone, country) VALUES
('TechSupply Co.',    'John Smith',  'john@techsupply.com',  '+1-800-0001', 'USA'),
('MidEast IT Hub',    'Sara Khalil', 'sara@meit.com',        '+961-1-0002', 'Lebanon'),
('Global Networks',   'Wei Zhang',   'wei@globalnet.com',    '+86-21-0003', 'China');

-- Warehouses
INSERT INTO Warehouses (warehouse_name, location, manager_id, capacity) VALUES
('Main Warehouse',   'Beirut, Lebanon',  2, 5000),
('North Storage',    'Tripoli, Lebanon', 2, 2000);

-- Products
INSERT INTO Products (category_id, product_name, SKU, unit_price, reorder_level, unit) VALUES
(1, 'Cisco Catalyst 2960 Switch', 'NET-SW-001', 450.00,  5,  'unit'),
(1, 'TP-Link Archer AX6000 Router','NET-RT-002', 189.99,  8,  'unit'),
(1, 'Cat6 Ethernet Cable 1m',     'CBL-ET-003',   2.50, 50,  'roll'),
(2, 'Intel Core i7-13700K CPU',   'CPU-I7-004',  380.00, 10,  'unit'),
(2, 'Kingston 32GB DDR5 RAM',     'RAM-KG-005',   95.00, 15,  'unit'),
(2, 'Samsung 1TB SSD',            'STO-SS-006',  110.00, 10,  'unit'),
(3, 'Dell 27" Monitor',           'MON-DL-007',  320.00,  5,  'unit'),
(3, 'Logitech MX Keys Keyboard',  'PER-LG-008',   99.00, 10,  'unit'),
(4, 'Windows 11 Pro License',     'LIC-WN-009',  199.00, 20,  'license'),
(5, 'HDMI 2.1 Cable 2m',          'CBL-HD-010',    8.99, 30,  'piece');

-- Stock
INSERT INTO Stock (product_id, warehouse_id, quantity) VALUES
(1,  1, 12), (1,  2,  3),
(2,  1, 20), (2,  2,  5),
(3,  1, 200),(3,  2, 80),
(4,  1, 25), (4,  2,  8),
(5,  1, 60), (5,  2, 20),
(6,  1, 40), (6,  2, 15),
(7,  1, 10), (7,  2,  2),
(8,  1, 30),
(9,  1, 100),
(10, 1, 150),(10, 2, 50);

-- ProductSuppliers (M:M)
INSERT INTO ProductSuppliers (product_id, supplier_id, supply_price, lead_time_days, is_preferred) VALUES
(1, 1, 380.00, 7,  TRUE),
(1, 3, 370.00, 14, FALSE),
(2, 2, 150.00, 3,  TRUE),
(4, 1, 320.00, 5,  TRUE),
(5, 2,  75.00, 3,  TRUE),
(6, 3,  85.00, 10, TRUE),
(9, 1, 160.00, 2,  TRUE);

-- Purchase Orders
INSERT INTO PurchaseOrders (supplier_id, ordered_by, warehouse_id, expected_date, status, total_amount) VALUES
(1, 2, 1, '2026-05-25', 'Approved',  2280.00),
(2, 2, 1, '2026-05-22', 'Pending',    750.00),
(3, 2, 2, '2026-06-01', 'Pending',   1020.00);

-- Purchase Order Items
INSERT INTO PurchaseOrderItems (po_id, product_id, quantity, unit_cost) VALUES
(1, 1, 5, 380.00),  -- 5x Cisco Switch
(1, 4, 3, 320.00),  -- 3x CPU
(2, 2, 5, 150.00),  -- 5x TP-Link Router
(3, 6, 12, 85.00);  -- 12x Samsung SSD

-- Stock Transactions
INSERT INTO StockTransactions (product_id, warehouse_id, performed_by, txn_type, quantity, notes) VALUES
(1, 1, 3, 'IN',         10, 'Initial stock receipt'),
(2, 1, 3, 'IN',         20, 'Initial stock receipt'),
(3, 1, 3, 'IN',        200, 'Bulk cable order'),
(4, 1, 4, 'OUT',        -3, 'Issued to IT dept'),
(5, 1, 4, 'OUT',        -5, 'Issued to IT dept'),
(1, 1, 2, 'ADJUSTMENT', -2, 'Damaged units removed');
