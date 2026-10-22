# 📦 CSD Depot & URC Supply Chain & Inventory Analytics

A comprehensive end-to-end data analytics and supply chain project built to monitor, analyze, and optimize inventory performance, URC (Unit Run Canteen) distribution, stock fill rates, and sales trends for CSD (Canteen Stores Department) depots.

---

## 🚀 Project Overview
This project simulates real-world FMCG and retail distribution data management within military/civil canteens. It bridges raw transactional data with robust relational modeling, advanced SQL queries, and Power BI interactive dashboards to track inventory health, prevent stockouts, and evaluate supplier and depot performance.

---

## 🛠️ Tech Stack & Tools
* **Database & Querying:** MySQL Workbench (Relational Schema Design, Joins, Window Functions, Aggregations)
* **Data Visualization & Modeling:** Power BI Desktop (Power Query, DAX, Interactive Dashboards)
* **Data Processing:** Microsoft Excel (Data cleaning, case-pack normalization, validation)
* **Version Control:** Git & GitHub

---

## 📊 Key Dashboard Metrics & KPIs
* **Total Stock Units:** 224,198
* **Total Sold Units:** 165,318
* **Total Received Units:** 199,937
* **Active Depots Monitored:** 13
* **Unique URCs Tracked:** 494

---

## 🗄️ Database Schema

### 1. `Depot_Stock_Summary` (Parent Table)
Stores opening stock, receipts, sales, closing stock, and reorder status at the depot level.
* `INDEX_NUM` (INT) - Product Index Number
* `DESCRIPTION` (VARCHAR) - Product Description / SKU Name
* `DEPOT` (VARCHAR) - Depot Location Name
* `SUPPLIER_NAME` (VARCHAR) - Manufacturer/Supplier Name
* `CASE_PACK` (INT) - Conversion factor (Units per Case)
* `OPENING_CS`, `OPENING_UN` (INT) - Opening Cases and Units
* `REC_CS`, `REC_UN` (INT) - Received Cases and Units
* `SELL_CS`, `SELL_UN` (INT) - Sold Cases and Units
* `STOCK_CS`, `STOCK_UN` (INT) - Current Stock Cases and Units
* `DNL_CS`, `DNL_UN` (INT) - Demand Not Lifted (Pending Orders)
* `STOCK_STATUS` (VARCHAR) - Inventory Health Indicator ('SUFFICIENT STOCK', 'LOW STOCK - REORDER', 'OUT OF STOCK')

### 2. `URC_Distribution_Data` (Child Table)
Tracks item-wise distribution and sales across various Unit Run Canteens (URCs).
* `DEPOT` (VARCHAR) - Associated Depot
* `GP` (INT) - Group Code
* `INDEX_NUM` & `DESCRIPTION` (INT/VARCHAR) - SKU Identifier
* `URC_NAME` (VARCHAR) - Specific Canteen Name
* `Sale_CS`, `sale_UN` (INT) - Canteen-wise Sales in Cases and Units

---

## 🔍 Key SQL Analytical Queries Included
The project's SQL script (`CSD_Analysis_SQL.sql`) answers critical business questions:
1. **Dynamic Case-Pack Conversion:** Calculates precise total equivalent units using parent-child table joins (`(Sale_CS * CASE_PACK) + sale_UN`).
2. **Stock Fill Rate & Performance:** Links depot stock levels with URC demand.
3. **Inventory Alerts:** Filters `OUT OF STOCK` and `LOW STOCK - REORDER` items to prevent supply chain bottlenecks.
4. **Sales Ranking:** Utilizes window functions (`RANK() OVER (PARTITION BY DEPOT...)`) to rank top-selling products per depot.
5. **Top Consuming URCs:** Identifies top 5 highest-consuming canteens by total units sold.
6. **Supplier Performance:** Evaluates total sales volume driven by each supplier.
7. **Pending Orders (DNL):** Tracks highest Demand Not Lifted quantities to optimize fulfillment.

---

## 🚀 How to Run the Project
1. Clone the repository:
   ```bash
   git clone https://github.com/Achalvlog/CSD-Sales-Inventory-Analytics-Dashboard.git
