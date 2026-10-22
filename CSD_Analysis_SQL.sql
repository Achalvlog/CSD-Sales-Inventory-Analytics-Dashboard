
CREATE DATABASE CSD_Depot_Analytics;

USE CSD_Depot_Analytics;

-- 1. Table Depot
CREATE TABLE Depot_Stock_Summary (
    INDEX_NUM INT,
    DESCRIPTION VARCHAR(255),
    DEPOT VARCHAR(100),
    SUPPLIER_NAME VARCHAR(255),
    MONTH VARCHAR(20),
    CASE_PACK INT,
    OPENING_CS INT,
    OPENING_UN INT,
    REC_CS INT,
    REC_UN INT,
    SELL_CS INT,
    SELL_UN INT,
    STOCK_CS INT,
    STOCK_UN INT,
    DNL_CS INT,
    DNL_UN INT,
    STOCK_STATUS VARCHAR(50)
);

-- 2. URC Table
CREATE TABLE URC_Distribution_Data (
    DEPOT VARCHAR(100),
    GP INT,
    SUPPLIER_NAME VARCHAR(255),
    MONTH VARCHAR(20),
    INDEX_NUM INT,
    DESCRIPTION VARCHAR(255),
    URC_NAME VARCHAR(255),
    Sale_CS INT,
    sale_UN INT
);

-- Total Equivalent unit

SELECT 
    u.DEPOT,
    u.INDEX_NUM,
    u.DESCRIPTION,
    u.URC_NAME,
    u.Sale_CS,
    u.sale_UN,
    d.CASE_PACK,
    ((u.Sale_CS * d.CASE_PACK) + u.sale_UN) AS Total_Equivalent_Units
FROM URC_Distribution_Data u
JOIN Depot_Stock_Summary d 
    ON u.DEPOT = d.DEPOT AND u.INDEX_NUM = d.INDEX_NUM
ORDER BY Total_Equivalent_Units DESC;


-- Depot wise stock fill rate & performance


SELECT 
    d.DEPOT, 
    d.INDEX_NUM, 
    d.DESCRIPTION, 
    d.STOCK_CS AS Depot_Stock_Cases, 
    u.Sale_CS AS URC_Sale_Cases
FROM Depot_Stock_Summary d
JOIN URC_Distribution_Data u 
    ON d.DEPOT = u.DEPOT AND d.INDEX_NUM = u.INDEX_NUM;
    
    
   -- Out Of Stock and Low stock
   
   SELECT 
    DEPOT,
    INDEX_NUM,
    DESCRIPTION,
    STOCK_STATUS,
    STOCK_CS,
    STOCK_UN
FROM Depot_Stock_Summary
WHERE STOCK_STATUS IN ('OUT OF STOCK', 'LOW STOCK - REORDER');


-- Ranking Top Selling Items per Depot


SELECT 
    u.DEPOT,
    u.INDEX_NUM,
    u.DESCRIPTION,
    d.CASE_PACK,
    ((u.Sale_CS * d.CASE_PACK) + u.sale_UN) AS Total_Units,
    RANK() OVER (
        PARTITION BY u.DEPOT 
        ORDER BY ((u.Sale_CS * d.CASE_PACK) + u.sale_UN) DESC
    ) AS sales_rank
FROM URC_Distribution_Data u
JOIN Depot_Stock_Summary d 
    ON u.DEPOT = d.DEPOT AND u.INDEX_NUM = d.INDEX_NUM;
    
    
    -- Top 5 Highest Consuming URCs
    
    SELECT 
    u.URC_NAME,
    u.DEPOT,
    SUM((u.Sale_CS * d.CASE_PACK) + u.sale_UN) AS Total_Consumed_Units
FROM URC_Distribution_Data u
JOIN Depot_Stock_Summary d 
    ON u.DEPOT = d.DEPOT AND u.INDEX_NUM = d.INDEX_NUM
GROUP BY u.URC_NAME, u.DEPOT
ORDER BY Total_Consumed_Units DESC
LIMIT 5;
    
    
    -- Depot-wise & URC-wise Highest Sales
    
    
    SELECT 
    u.DEPOT,
    u.URC_NAME,
    d.CASE_PACK,
    ((u.Sale_CS * d.CASE_PACK) + u.sale_UN) AS Total_Sale_Units
FROM URC_Distribution_Data u
JOIN Depot_Stock_Summary d 
    ON u.DEPOT = d.DEPOT AND u.INDEX_NUM = d.INDEX_NUM
ORDER BY Total_Sale_Units DESC;


-- Highest Selling Product / Top SKUs

SELECT 
    u.INDEX_NUM,
    u.DESCRIPTION,
    SUM((u.Sale_CS * d.CASE_PACK) + u.sale_UN) AS Total_Units_Sold
FROM URC_Distribution_Data u
JOIN Depot_Stock_Summary d 
    ON u.DEPOT = d.DEPOT AND u.INDEX_NUM = d.INDEX_NUM
GROUP BY u.INDEX_NUM, u.DESCRIPTION
ORDER BY Total_Units_Sold DESC
LIMIT 5;


-- Low Stock & High Stock Alerts

SELECT DEPOT, INDEX_NUM, DESCRIPTION, STOCK_STATUS, STOCK_CS, STOCK_UN 
FROM Depot_Stock_Summary 
WHERE STOCK_STATUS = 'LOW STOCK - REORDER';

-- Highest Opening Stock by Depot

SELECT 
    DEPOT,
    SUM((OPENING_CS * CASE_PACK) + OPENING_UN) AS Total_Opening_Units
FROM Depot_Stock_Summary
GROUP BY DEPOT
ORDER BY Total_Opening_Units DESC;

-- Total Sales & Total Receiving Summary

SELECT 
    DEPOT,
    SUM((REC_CS * CASE_PACK) + REC_UN) AS Total_Received_Units,
    SUM((SELL_CS * CASE_PACK) + SELL_UN) AS Total_Sold_Units
FROM Depot_Stock_Summary
GROUP BY DEPOT;


-- Highest DNL / Pending Orders


SELECT 
    DEPOT,
    INDEX_NUM,
    DESCRIPTION,
    ((DNL_CS * CASE_PACK) + DNL_UN) AS Total_DNL_Units
FROM Depot_Stock_Summary
ORDER BY Total_DNL_Units DESC
LIMIT 10;