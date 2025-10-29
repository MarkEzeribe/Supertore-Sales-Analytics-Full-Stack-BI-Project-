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
      
## Project Architecture
The architecture follows a classic **ETL pipeline** design:  
data is ingested from multiple file types, standardized in SQL Server, modeled into star-schema tables,  
and then visualized in Power BI.

*More detailed process documentation is available in the (https://github.com/user-attachments/files/23190599/SSIS.Report.pdf)



###  1. Staging Layer
- Raw **CSV**, **TXT**, and **XML** files are imported through **SSIS** into the `Sales.Staging` table.  
- This layer acts as the **landing zone** for all source files.  
- Data is cleaned and standardized (e.g., trimmed whitespace, converted data types, and validated column formats).



###  2. SQL Schema & Data Modeling
- Data is first organized in **Third Normal Form (3NF)** within the Sales schema to ensure data integrity and eliminate redundancy.  
- The resulting design follows a **Star Schema structure** — a central fact table surrounded by related dimension tables — to support efficient analytics in Power BI.  
  - Dimension tables: `Sales.Customer`, `Sales.Product`, `Sales.Geography`, `Sales.Segment`, etc.  
  - Fact table: `Sales.FactSalesOrderDetail` connects all dimensions through foreign keys.  
- Each table includes a `LastLoadDate` column to support **ETL auditing** and **data lineage tracking**.

<img width="787" height="748" alt="DataBase Digram" src="https://github.com/user-attachments/assets/3eb1ce8d-4ec5-4a2f-a6bd-7454c6024fde" />


###  3. ETL (UPSERT Logic)
- Incremental loads keep data synchronized between **Staging** and the main **Sales schema**.  
- The UPSERT process uses **transactions, joins, and idempotent logic** to safely handle new and changed records.  
- Example stored procedure calls:
    - EXEC sp_Upsert_GeographyTable;
    - EXEC sp_Upsert_CustomerTable;
   - EXEC sp_Upsert_FactSalesOrderDetailTable; etc.
<img width="700" height="700" alt="Load ODS tables" src="https://github.com/user-attachments/assets/14d6e5d6-e93b-4049-98c3-87f8c3f044db" />
<img width="700" height="700" alt="upsert " src="https://github.com/user-attachments/assets/9362aa46-c35d-4b0d-81d6-98e40b3fc443" />

## Power BI Dashboard

Power BI pulls data directly from the SQL Server tables created in this project.  
This allows the dashboard to show real-time sales and profit insights without manual updates

#### Dashboard Highlights
-  **KPI Cards:** Total Sales, Profit, and Profit Margin  
-  **Regional Sales Breakdown:** Visual map of sales performance across U.S. regions  
-  **Category & Subcategory Analysis:** Product group contribution to revenue  
-  **Customer Segment Comparison:** Consumer vs Corporate vs Home Office  
-  **Sales Trends:** Year-over-Year growth and profitability patterns  

**Purpose:**  
To provide clear, interactive insights that help management identify opportunities, track performance, and improve decision-making.



### Key Business Insights
Summarized from the included report:  
📄 **[Sales Analytics Report.pdf](./Docs/Sales%20Analytics%20Report.pdf)**

| KPI | Definition | Key Findings |
|------|-------------|--------------|
| **Total Sales** | Sum of all transactions | Over **$2.3M**, led by West & East regions |
| **Total Profit** | Net profit after discounts | Continuous growth with a peak in 2014 |
| **Profit Margin (%)** | Profit ÷ Sales | ~11.6% overall – healthy margins |
| **Sales by Region** | Revenue contribution | West > $600K; South underperforms |
| **Customer Segments** | Profitability by segment | Consumer segment drives most sales |





## Tech Stack
- SQL Server Management Studio (SSMS)
- SQL Server Integration Services (SSIS)
- Power BI Desktop
- Excel 
- T-SQL Stored Procedures
