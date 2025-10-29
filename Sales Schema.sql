------------------------------------------------------------------------------
-- Project: SuperStoreUSA Analytics Database
-- Author : Mark Ezeribe
-- Date    : 2025-10-28
-- Purpose: Create database, schema, and normalized tables
--           to support Sales data warehouse design.
-- Notes  : Implements 3NF tables with primary and foreign key relationships,
--          including LastLoadDate columns for ETL auditing and traceability
---------------------------------------------------------------------------------

-----------------------------------------------------
--Step 1: Create database (run once per environment)
-----------------------------------------------------
CREATE DATABASE SuperStoreUSA

GO

USE SuperStoreUSA;
GO

---------------------------------------------------------
--Step 2: Create a schema to avoid the generic dbo schema
----------------------------------------------------------
CREATE SCHEMA Sales

-----------------------
--Step 3: Create Staging Table
------------------------
CREATE TABLE Sales.Staging
(
	RowID        INT
,	OrderID      VARCHAR    (20)
,	OrderDate    DATE
,	ShipDate     DATE
,	ShipMode     VARCHAR    (20)
,	CustomerID   VARCHAR    (15)
,	CustomerName VARCHAR    (30)
,	Segment      VARCHAR    (20)
,	Country      VARCHAR    (20)
,	City         VARCHAR    (20)
,	[State]      VARCHAR    (30)
,	PostalCode   VARCHAR    (10)
,	Region       VARCHAR    (10)
,	ProductID    VARCHAR    (20)
,	Category     VARCHAR    (20)
,	SubCategory  VARCHAR    (20)
,	ProductName  VARCHAR    (140)
,	Sales        DECIMAL    (17,4)
,	Quantity     INT
,	Discount     DECIMAL    (3,3)
,	Profit       DECIMAL    (17,4)
)

-------------------------
--Step 4: Create Geography Table
-------------------------
CREATE TABLE Sales.[Geography]
(
	GeographyID     INT      IDENTITY (1,1)                                             NOT NULL
,	Country         VARCHAR           (20)                                              NOT NULL
,	Region          VARCHAR           (10)                                              NOT NULL
,	[State]         VARCHAR           (30)                                              NOT NULL
,	City            VARCHAR           (30)                                              NOT NULL
,	PostalCode      VARCHAR           (10)                                              NOT NULL
,	LastLoadDate    DATETIME CONSTRAINT [DF_Geography_LastLoadDate] DEFAULT GETDATE()	NOT NULL
,	CONSTRAINT                          [PK_GeographyID]            PRIMARY KEY (GeographyID)
)

-------------------------
--Step 5: Create Customer Table
-------------------------
CREATE TABLE Sales.Customer
(
	CustomerID      INT      IDENTITY (1,1)                                                  NOT NULL
,	CustomerNumber  VARCHAR      (15)                                                   NOT NULL
,	CustomerName    VARCHAR      (30)                                                   NOT NULL
,	LastLoadDate    DATETIME CONSTRAINT [DF_Customer_LastLoadDate] DEFAULT GETDATE()	NOT NULL
,	CONSTRAINT                          [PK_CustomerID]            PRIMARY KEY (CustomerID)
) 


-----------------------
--Step 6: Create Product Table
------------------------
CREATE TABLE Sales.[Product]
(
	ProductID       INT     IDENTITY  (1,1)                                             NOT NULL
,	ProductName	    VARCHAR          (140)                                             NOT NULL
,	LastLoadDate   DATETIME CONSTRAINT [DF_Product_LastLoadDate] DEFAULT GETDATE()	NOT NULL
,	CONSTRAINT [PK_ProductID] PRIMARY KEY (ProductID)
)

--------------------------------
--Step 7: Create ProductCategory Table
--------------------------------
CREATE TABLE Sales.ProductCategory
(
	ProductCategoryID  INT       IDENTITY      (1,1)                                              NOT NULL
,	ProductCategory    VARCHAR                 (20)                                               NOT NULL
,	LastLoadDate DATETIME CONSTRAINT [DF_ProductCategory_LastLoadDate] DEFAULT GETDATE()	NOT NULL
,	CONSTRAINT [PK_ProductCategoryID] PRIMARY KEY (ProductCategoryID)
)

------------------------------------
--Step 8: Create ProductSubCategory Table
------------------------------------
CREATE TABLE Sales.ProductSubCategory
(
	ProductSubCategoryID    INT              IDENTITY (1,1)								    NOT NULL
,	ProductSubCategory      VARCHAR(20)													    NOT NULL
,	LastLoadDate DATETIME CONSTRAINT [DF_ProductSubCategory_LastLoadDate] DEFAULT GETDATE()	NOT NULL
,	CONSTRAINT [PK_ProductSubCategoryID] PRIMARY KEY (ProductSubCategoryID)
)

-------------------------
--Step 9: Create ShipMode Table
--------------------------
CREATE TABLE Sales.ShipMode
(
	ShipModeID    INT        IDENTITY (1,1)											NOT NULL
,	ShipMode      VARCHAR             (20)											NOT NULL
,	LastLoadDate DATETIME CONSTRAINT [DF_ShipMode_LastLoadDate] DEFAULT GETDATE()	NOT NULL
,	CONSTRAINT [PK_ShipModeID] PRIMARY KEY (ShipModeID)
)

-----------------------
--Step 10: Create Segment Table
------------------------
CREATE TABLE Sales.Segment
(
	SegmentID	INT			IDENTITY (1,1)											NOT NULL
,	Segment		VARCHAR				 (20)											NOT NULL
,	LastLoadDate DATETIME CONSTRAINT [DF_Segment_LastLoadDate] DEFAULT GETDATE()	NOT NULL
,	CONSTRAINT [PK_SegmentID] PRIMARY KEY (SegmentID)
)

-------------------------------------
--Step 11: Create FactSalesOrderDetail Table
--------------------------------------
CREATE TABLE Sales.FactSalesOrderDetail
(
	FactSalesOrderDetailID INT IDENTITY (1,1)                                                   NOT NULL
,	OrderDate              DATE																	NOT NULL
,	ShipDate               DATE																	NOT NULL
,	OrderID                VARCHAR(20)                                                          NOT NULL
,	CustomerID             INT																	NOT NULL
,	GeographyID            INT																	NOT NULL
,	SegmentID              INT																	NOT NULL
,	ShipModeID             INT																	NOT NULL
,	ProductID              INT																	NOT NULL
,	ProductCategoryID      INT																	NOT NULL
,	ProductSubCategoryID   INT																	NOT NULL
,	Sales                  DECIMAL (19,4)                                                       NOT NULL
,	Profit                 DECIMAL (19,4)                                                       NOT NULL
,	Discount               DECIMAL(3,3)                                                         NOT NULL
,	Quantity               INT                                                                  NOT NULL
,	LastLoadDate DATETIME CONSTRAINT [DF_FactSalesOrderDetail_LastLoadDate] DEFAULT GETDATE()	NOT NULL
,	CONSTRAINT [PK_FactSalesOrderDetailID]					PRIMARY KEY (FactSalesOrderDetailID)
,	CONSTRAINT [FK_Customer_CustomerID]						FOREIGN KEY (CustomerID)			REFERENCES Sales.Customer(CustomerID)
,	CONSTRAINT [FK_ShipMode_ShipModeID]						FOREIGN KEY (ShipModeID)			REFERENCES Sales.ShipMode(ShipModeID)
,	CONSTRAINT [FK_Segment_SegmentID]						FOREIGN KEY (SegmentID)				REFERENCES Sales.Segment(SegmentID)
,	CONSTRAINT [FK_Geography_GeographyID]				    FOREIGN KEY (GeographyID)			REFERENCES Sales.[Geography](GeographyID)
,	CONSTRAINT [FK_Product_ProductID]						FOREIGN KEY (ProductID)				REFERENCES Sales.[Product](ProductID)
,	CONSTRAINT [FK_ProductCategory_ProductCategoryID]       FOREIGN KEY (ProductCategoryID)		REFERENCES Sales.ProductCategory(ProductCategoryID)
,	CONSTRAINT [FK_ProductSubCategory_ProductSubCategoryID] FOREIGN KEY (ProductSubCategoryID)	REFERENCES Sales.ProductSubCategory(ProductSubCategoryID)
)

