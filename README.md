# Superstore Sales Analytics (Full-Stack BI Project)
## Project Overview
This project demonstrates a **complete end-to-end Business Intelligence (BI)** workflow for **SuperStoreUSA** from raw sales data to an automated reporting system.  
It showcases **data modeling, ETL automation, and Power BI dashboarding** built with Microsoft’s BI stack.
The goal is to **analyze sales performance** and uncover insights on profit trends, top-performing products, and regional growth opportunities.
, using the [Superstore Sales dataset](https://www.kaggle.com/datasets/ishanshrivastava28/superstore-sales).

## Problem Statement
This project addresses **two key challenges** faced by SuperStore:

1. **Data Integration and Quality**
   - SuperStore receives sales data in **CSV, TXT, and XML** formats without a consistent loading process.  
   - This causes **data type mismatches**, **duplicate or changed records**, and **slow reprocessing** during refresh cycles.  
   - A **repeatable SSIS pipeline** was required to standardize these files into a unified **staging table** on each run, followed by **incremental upserts** into **star schema tables** (dimensions first, then fact).  
   - The goal was to ensure **clean, reliable, and up-to-date data** for downstream Power BI analytics — improving **data freshness, integrity, and operational reporting.**

2. **Business Performance and Profitability**
   - SuperStore, a U.S. retailer specializing in **furniture, office supplies, and technology**, has achieved strong sales but continues to face challenges in **profitability and customer retention**.  
   - Sales performance is **uneven across regions and customer segments**, and **profit margins** remain under pressure.  
   - Year-over-year growth has slowed, raising concerns about **long-term competitiveness** and **data management efficiency**.  
   - Management required a solution that would:
     - Integrate sales data from multiple sources into a secure, centralized **Operational Data Store (ODS)**.  
     - Provide a **Power BI business intelligence report** offering data-driven insights to:
       - Improve customer retention and loyalty  
       - Evaluate profitability across customer segments  
       - Understand regional sales performance and growth trends  
       - Monitor sales and profit margins to guide sustainable business decisions
      
## ⚙️ Project Architecture
The architecture follows a classic **ETL pipeline** design:  
data is ingested from multiple file types, standardized in SQL Server, modeled into star-schema tables,  
and then visualized in Power BI.

*More detailed process documentation is available in the [Sales Analytics Report.pdf](./Docs/Sales%20Analytics%20Report.pdf).*

---

### 🔹 1. Staging Layer
- Raw **CSV**, **TXT**, and **XML** files are imported through **SSIS** into the `Sales.Staging` table.  
- This layer acts as the **landing zone** for all source files.  
- Data is cleaned and standardized (e.g., trimmed whitespace, converted data types, and validated column formats).

---

### 🔹 2. SQL Schema & Data Modeling
- Data is normalized into **Third Normal Form (3NF)** using dimension and fact tables:  
  - `Sales.Customer`, `Sales.Product`, `Sales.Geography`, `Sales.Segment`, etc.  
  - `Sales.FactSalesOrderDetail` joins all dimensions through foreign keys.  
- Each table includes a `LastLoadDate` column to support **ETL auditing** and **data lineage tracking**.

---

### 🔹 3. ETL (UPSERT Logic)
- Incremental loads keep data synchronized between **Staging** and the main **Sales schema**.  
- The UPSERT process uses **transactions, joins, and idempotent logic** to safely handle new and changed records.  
- Example stored procedure calls:
  ```sql
  EXEC sp_Upsert_GeographyTable;
  EXEC sp_Upsert_CustomerTable;
  EXEC sp_Upsert_FactSalesOrderDetailTable; 

## Tech Stack
- SQL Server Management Studio (SSMS)
- SQL Server Integration Services (SSIS)
- Power BI Desktop
- Excel 
- T-SQL Stored Procedures
