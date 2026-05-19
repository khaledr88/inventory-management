// data.js — matches seed_data.sql exactly
// When backend is ready, replace these with fetch() calls to PHP API

const ROLES = [
  {role_id:1, role_name:'Admin'},
  {role_id:2, role_name:'Manager'},
  {role_id:3, role_name:'Staff'}
];

const USERS = [
  {user_id:1, role_id:1, full_name:'Alice Admin',  email:'alice@inv.com', is_active:true},
  {user_id:2, role_id:2, full_name:'Bob Manager',  email:'bob@inv.com',   is_active:true},
  {user_id:3, role_id:3, full_name:'Carol Staff',  email:'carol@inv.com', is_active:true},
  {user_id:4, role_id:3, full_name:'Dave Staff',   email:'dave@inv.com',  is_active:true}
];

const CATEGORIES = [
  {category_id:1, category_name:'Networking Equipment'},
  {category_id:2, category_name:'Computing Hardware'},
  {category_id:3, category_name:'Peripherals'},
  {category_id:4, category_name:'Software Licenses'},
  {category_id:5, category_name:'Cables & Connectors'}
];

const SUPPLIERS = [
  {supplier_id:1, company_name:'TechSupply Co.',  contact_name:'John Smith',  email:'john@techsupply.com', country:'USA'},
  {supplier_id:2, company_name:'MidEast IT Hub',  contact_name:'Sara Khalil', email:'sara@meit.com',       country:'Lebanon'},
  {supplier_id:3, company_name:'Global Networks', contact_name:'Wei Zhang',   email:'wei@globalnet.com',   country:'China'}
];

const WAREHOUSES = [
  {warehouse_id:1, warehouse_name:'Main Warehouse', location:'Beirut, Lebanon',  capacity:5000},
  {warehouse_id:2, warehouse_name:'North Storage',  location:'Tripoli, Lebanon', capacity:2000}
];

const PRODUCTS = [
  {product_id:1,  category_id:1, product_name:'Cisco Catalyst 2960 Switch',  SKU:'NET-SW-001', unit_price:450.00, reorder_level:5},
  {product_id:2,  category_id:1, product_name:'TP-Link Archer AX6000 Router',SKU:'NET-RT-002', unit_price:189.99, reorder_level:8},
  {product_id:3,  category_id:5, product_name:'Cat6 Ethernet Cable 1m',      SKU:'CBL-ET-003', unit_price:2.50,   reorder_level:50},
  {product_id:4,  category_id:2, product_name:'Intel Core i7-13700K CPU',    SKU:'CPU-I7-004', unit_price:380.00, reorder_level:10},
  {product_id:5,  category_id:2, product_name:'Kingston 32GB DDR5 RAM',      SKU:'RAM-KG-005', unit_price:95.00,  reorder_level:15},
  {product_id:6,  category_id:2, product_name:'Samsung 1TB SSD',             SKU:'STO-SS-006', unit_price:110.00, reorder_level:10},
  {product_id:7,  category_id:3, product_name:'Dell 27" Monitor',            SKU:'MON-DL-007', unit_price:320.00, reorder_level:5},
  {product_id:8,  category_id:3, product_name:'Logitech MX Keys Keyboard',   SKU:'PER-LG-008', unit_price:99.00,  reorder_level:10},
  {product_id:9,  category_id:4, product_name:'Windows 11 Pro License',      SKU:'LIC-WN-009', unit_price:199.00, reorder_level:20},
  {product_id:10, category_id:5, product_name:'HDMI 2.1 Cable 2m',           SKU:'CBL-HD-010', unit_price:8.99,   reorder_level:30}
];

const STOCK = [
  {stock_id:1,  product_id:1,  warehouse_id:1, quantity:12},
  {stock_id:2,  product_id:1,  warehouse_id:2, quantity:3},
  {stock_id:3,  product_id:2,  warehouse_id:1, quantity:20},
  {stock_id:4,  product_id:2,  warehouse_id:2, quantity:5},
  {stock_id:5,  product_id:3,  warehouse_id:1, quantity:200},
  {stock_id:6,  product_id:3,  warehouse_id:2, quantity:80},
  {stock_id:7,  product_id:4,  warehouse_id:1, quantity:25},
  {stock_id:8,  product_id:4,  warehouse_id:2, quantity:8},
  {stock_id:9,  product_id:5,  warehouse_id:1, quantity:60},
  {stock_id:10, product_id:5,  warehouse_id:2, quantity:20},
  {stock_id:11, product_id:6,  warehouse_id:1, quantity:40},
  {stock_id:12, product_id:6,  warehouse_id:2, quantity:15},
  {stock_id:13, product_id:7,  warehouse_id:1, quantity:10},
  {stock_id:14, product_id:7,  warehouse_id:2, quantity:2},
  {stock_id:15, product_id:8,  warehouse_id:1, quantity:30},
  {stock_id:16, product_id:9,  warehouse_id:1, quantity:100},
  {stock_id:17, product_id:10, warehouse_id:1, quantity:150},
  {stock_id:18, product_id:10, warehouse_id:2, quantity:50}
];

const PURCHASE_ORDERS = [
  {po_id:1, supplier_id:1, ordered_by:2, warehouse_id:1, order_date:'2026-05-19', expected_date:'2026-05-25', status:'Approved',  total_amount:2280},
  {po_id:2, supplier_id:2, ordered_by:2, warehouse_id:1, order_date:'2026-05-19', expected_date:'2026-05-22', status:'Pending',   total_amount:750},
  {po_id:3, supplier_id:3, ordered_by:2, warehouse_id:2, order_date:'2026-05-19', expected_date:'2026-06-01', status:'Pending',   total_amount:1020}
];

const PO_ITEMS = [
  {item_id:1, po_id:1, product_id:1, quantity:5,  unit_cost:380},
  {item_id:2, po_id:1, product_id:4, quantity:3,  unit_cost:320},
  {item_id:3, po_id:2, product_id:2, quantity:5,  unit_cost:150},
  {item_id:4, po_id:3, product_id:6, quantity:12, unit_cost:85}
];

const TRANSACTIONS = [
  {txn_id:1, product_id:1, warehouse_id:1, performed_by:3, txn_type:'IN',         quantity:10,  notes:'Initial stock receipt', txn_date:'2026-05-01'},
  {txn_id:2, product_id:2, warehouse_id:1, performed_by:3, txn_type:'IN',         quantity:20,  notes:'Initial stock receipt', txn_date:'2026-05-01'},
  {txn_id:3, product_id:3, warehouse_id:1, performed_by:3, txn_type:'IN',         quantity:200, notes:'Bulk cable order',       txn_date:'2026-05-02'},
  {txn_id:4, product_id:4, warehouse_id:1, performed_by:4, txn_type:'OUT',        quantity:-3,  notes:'Issued to IT dept',      txn_date:'2026-05-10'},
  {txn_id:5, product_id:5, warehouse_id:1, performed_by:4, txn_type:'OUT',        quantity:-5,  notes:'Issued to IT dept',      txn_date:'2026-05-10'},
  {txn_id:6, product_id:1, warehouse_id:1, performed_by:2, txn_type:'ADJUSTMENT', quantity:-2,  notes:'Damaged units removed',  txn_date:'2026-05-15'}
];
