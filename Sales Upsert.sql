--------------------------------------------------------------------
-- Project : SuperStoreUSA Data Warehouse
-- Author  : Mark Ezeribe
-- Date    : 2025-10-28
-- Purpose : Contains stored procedures that update and insert
--           data from the Staging table into final Sales tables.
-- Notes   : Handles data refresh automatically, keeps tables 
--           up to date, and records LastLoadDate for ETL tracking.
----------------------------------------------------------------------

---------------------------
--Create Stored Procedure
---------------------------
CREATE PROCEDURE sp_Upsert_GeographyTable
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRAN;

--------------------------
--Update existing records
--------------------------
UPDATE t -- Target table

SET t.Country      = s.Country
,	t.Region       = s.Region
,	t.LastLoadDate = GETDATE()
FROM Sales.[Geography] t -----------Source table
INNER JOIN Sales.Staging s ON t.PostalCode = s.PostalCode AND t.[State] = s.[State] AND t.City = s.City  
WHERE t.Country <> s.Country OR  t.Region <> s.Region

-------------------------------------------
-- Insert new records that don’t exist yet
-------------------------------------------
INSERT INTO Sales.[Geography] (Country, Region, [State], City, PostalCode, LastLoadDate)
SELECT DISTINCT s.Country
,				s.Region
,				s.[State]
,				s.City
,				s.PostalCode
,				GETDATE()
FROM Sales.Staging s
LEFT JOIN Sales.[Geography] t ON  t.PostalCode = s.PostalCode AND t.[State] = s.[State] AND t.City = s.City AND t.Region = s.Region
WHERE t.GeographyID IS NULL;

COMMIT TRAN;	
END;
go


---------------------------- 
--Create Stored Procedure
-----------------------------
CREATE PROCEDURE sp_Upsert_CustomerTable
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRAN;

----------------------------
--Update existing Customer
-----------------------------
UPDATE t
SET t.LastLoadDate = GETDATE()
,	t.CustomerName = s.CustomerName 
FROM Sales.Customer t
INNER JOIN Sales.Staging s ON t.CustomerNumber = s.CustomerID
WHERE t.CustomerName <> s.CustomerName;

--------------------------------------------
-- Insert new Customer that don’t exist yet
--------------------------------------------
INSERT INTO Sales.Customer(CustomerNumber, CustomerName, LastLoadDate)
SELECT DISTINCT s.CustomerID
,				s.CustomerName
,				GETDATE()
FROM Sales.Staging s
LEFT JOIN Sales.Customer t ON s.CustomerID = t.CustomerNumber
WHERE t.CustomerID IS NULL;

COMMIT TRAN;	
END;
go

--------------------------
--Create Stored Procedure
---------------------------
CREATE PROCEDURE sp_Upsert_ProductTable
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRAN;

---------------------------
--Update existing products
---------------------------
UPDATE t
SET t.LastLoadDate = GETDATE()
FROM Sales.[Product] t
INNER JOIN Sales.Staging s ON t.ProductName = s.ProductName
WHERE t.ProductName <> s.ProductName;

---------------------------------------------
-- Insert new products that don’t exist yet
----------------------------------------------
INSERT INTO Sales.[Product] ( ProductName, LastLoadDate)
SELECT   DISTINCT s.ProductName
,		GETDATE()
FROM Sales.Staging s
LEFT JOIN Sales.[Product] t ON s.ProductName = t.ProductName
WHERE t.ProductID IS NULL;

COMMIT TRAN;	
END;
go


---------------------------
--Create Stored Procedure
----------------------------
CREATE PROCEDURE sp_Upsert_ProductCategoryTable
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRAN;

------------------------------------
--Update existing ProductCategory
-------------------------------------
UPDATE t
SET t.LastLoadDate = GETDATE()
FROM Sales.ProductCategory t
INNER JOIN Sales.Staging s ON t.ProductCategory = s.Category
WHERE t.ProductCategory <> s.Category;

---------------------------------------------------
-- Insert new ProductCategory that don’t exist yet
---------------------------------------------------
INSERT INTO Sales.ProductCategory (ProductCategory, LastLoadDate)
SELECT DISTINCT s.Category
,				GETDATE()
FROM Sales.Staging s 
LEFT JOIN Sales.ProductCategory t ON s.Category = t.ProductCategory
WHERE t.ProductCategoryID IS NULL;

COMMIT TRAN;	
END;
go

---------------------------
--Create Stored Procedure
----------------------------
CREATE PROCEDURE sp_Upsert_ProductSubCategoryTable
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRAN;

-------------------------------------
--Update existing ProductSubCategory
-------------------------------------
UPDATE t
SET t.LastLoadDate = GETDATE()
FROM Sales.ProductSubCategory t
INNER JOIN Sales.Staging s ON t.ProductSubCategory = s.SubCategory
WHERE t.ProductSubCategory <> s.SubCategory;

-------------------------------------------------------
-- Insert new ProductSubCategory that don’t exist yet
--------------------------------------------------------
INSERT INTO Sales.ProductSubCategory (ProductSubCategory, LastLoadDate)
SELECT DISTINCT s.SubCategory
,				GETDATE()
FROM Sales.Staging s
LEFT JOIN Sales.ProductSubCategory t ON s.SubCategory = t.ProductSubCategory
WHERE t.ProductSubCategoryID IS NULL;

COMMIT TRAN;	
END;
go



--------------------------
--Create Stored Procedure
--------------------------
CREATE PROCEDURE sp_Upsert_SegmentTable
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRAN;

--------------------------
--Update existing Segment
--------------------------
UPDATE t
SET t.LastLoadDate = GETDATE()
FROM Sales.Segment t
INNER JOIN Sales.Staging s ON t.Segment = s.Segment
WHERE t.Segment <> s.Segment;

--------------------------------------------
-- Insert new Segment that don’t exist yet
--------------------------------------------
INSERT INTO Sales.Segment (Segment, LastLoadDate)
SELECT DISTINCT s.Segment
,				GETDATE()
FROM Sales.Staging s
LEFT JOIN Sales.Segment t ON s.Segment = t.Segment
WHERE t.SegmentID IS NULL;

COMMIT TRAN;	
END;
go

---------------------------
--Create Stored Procedure
---------------------------
CREATE PROCEDURE sp_Upsert_ShipModeTable
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRAN;

---------------------------
--Update existing ShipMode
---------------------------
UPDATE t
SET t.LastLoadDate = GETDATE()
FROM Sales.ShipMode t
INNER JOIN Sales.Staging s ON t.ShipMode = s.ShipMode
WHERE t.ShipMode <> s.ShipMode;

--------------------------------------------
-- Insert new ShipMode that don’t exist yet
--------------------------------------------
INSERT INTO Sales.ShipMode (ShipMode, LastLoadDate)
SELECT DISTINCT s.ShipMode
,				GETDATE()
FROM Sales.Staging s
LEFT JOIN Sales.ShipMode t ON s.ShipMode = t.ShipMode
WHERE t.ShipModeID IS NULL;

COMMIT TRAN;	
END;
go

 

---------------------------- 
--Create Stored Procedure
-----------------------------	
CREATE PROCEDURE sp_Upsert_FactSalesOrderDetailTable
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRAN;

---------------------------
--Update existing records 
---------------------------
UPDATE t
SET t.OrderDate    = s.OrderDate
,	t.ShipDate     = s.ShipDate
,	t.Sales		   = s.Sales
,	t.Profit	   = s.Profit
,	t.Discount	   = s.Discount
,	t.Quantity     = s.Quantity
,	t.LastLoadDate = GETDATE()
FROM Sales.FactSalesOrderDetail t
INNER JOIN Sales.Staging s ON t.OrderID = s.OrderID

WHERE  t.OrderDate <> s.OrderDate
OR	   t.ShipDate  <> s.ShipDate 
OR	   t.Sales     <> s.Sales
OR	   t.Profit    <> s.Profit
OR	   t.Discount  <> s.Discount
OR	   t.Quantity  <> s.Quantity;

--------------------------------------------
-- Insert new records that don’t exist yet
--------------------------------------------
INSERT INTO Sales.FactSalesOrderDetail
(
	OrderDate
,	ShipDate
,	OrderID
,	CustomerID
,	GeographyID
,	SegmentID
,	ShipModeID
,	ProductID	
,	ProductCategoryID
,	ProductSubCategoryID
,	Sales
,	Profit
,	Discount
,	Quantity
,	LastLoadDate
)
SELECT DISTINCT
	s.OrderDate
,   s.ShipDate
,	s.OrderID
,	c.CustomerID
,	g.GeographyID
,	sg.SegmentID
,	sm.ShipModeID
,	p.ProductID
,	pc.ProductCategoryID
,	psc.ProductSubCategoryID
,	s.Sales
,	s.Profit
,	s.Discount
,	s.Quantity
,	GETDATE()
FROM Sales.Staging s
INNER JOIN Sales.ShipMode sm            ON s.ShipMode = sm.ShipMode
INNER JOIN Sales.Segment sg             ON s.Segment = sg.Segment
INNER JOIN Sales.[Geography] g          ON s.PostalCode = g.PostalCode AND s.[State] = g.[State] AND s.City = g.City AND s.Region = g.Region
INNER JOIN Sales.Customer c             ON s.CustomerName = c.CustomerName
INNER JOIN Sales.[Product] p            ON   s.ProductName = p.ProductName 
INNER JOIN Sales.ProductCategory pc     ON s.Category = pc.ProductCategory
INNER JOIN Sales.ProductSubCategory psc ON s.SubCategory = psc.ProductSubCategory
LEFT JOIN Sales.FactSalesOrderDetail t  ON s.OrderID = t.OrderID
WHERE t.FactSalesOrderDetailID IS NULL;

COMMIT TRAN;	
END;
go


