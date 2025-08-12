
/*=============================================================
1. Create Database and Schemas
2. DDL Script: Create Bronze Tables
3. Stored Procedure: Load Bronze Layer (Source -> Bronze)
=============================================================*/
/*=============================================================
1. Create Database and Schemas
=============================================================*/

USE masterr;  
GO
-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END; 
GO
  
-- Create databse 
CREATE DATABASE DataWarehouse; 
GO
USE DataWarehouse;    
GO
  
-- Create Schemas
CREATE SCHEMA bronze; 
GO
CREATE SCHEMA sliver; 
GO
CREATE SCHEMA gold;   
GO
  
/*===============================================================================
2. DDL Script: Create Bronze Tables
===============================================================================*/
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
BEGIN
	DROP TABLE bronze.crm_cust_info;  
END
GO
CREATE TABLE bronze.crm_cust_info (
	cst_id              INT,
	cst_key             NVARCHAR(50),
	cst_firstname       NVARCHAR(50),
	cst_lastname        NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr            NVARCHAR(50),
	cst_create_date     DATE
	);
GO
	
--Create temporary table for sales_details table
IF OBJECT_ID('bronze.crm_sales_details_staging', 'U') IS NOT NULL
BEGIN
	DROP TABLE bronze.crm_sales_details_staging;  
END
GO
CREATE TABLE bronze.crm_sales_details_staging (
	sls_ord_num   NVARCHAR(50),
	sls_prd_key   NVARCHAR(50),
	sls_cust_id   NVARCHAR(50), 
	sls_order_dt  NVARCHAR(50),
	sls_ship_dt   NVARCHAR(50),
	sls_sales     NVARCHAR(50),
	sls_quantity  NVARCHAR(50),
	sls_price     NVARCHAR(500)

);
GO	
--Create sales_detail table
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
BEGIN
	DROP TABLE bronze.crm_sales_details;  
END
GO
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num   NVARCHAR(50),
	sls_prd_key   NVARCHAR(50),
	sls_cust_id   INT,
	sls_order_dt  INT,
	sls_ship_dt   INT,
	sls_sales     INT,
	sls_quantity  INT,
	sls_price     INT

);
GO
	
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
BEGIN
	DROP TABLE  bronze.crm_prd_info;  
END
GO
CREATE TABLE bronze.crm_prd_info (
	prd_id       INT,
	prd_key      NVARCHAR(50),
	prd_nm       NVARCHAR(50),
	prd_cost     INT,
	prd_line     NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt   DATETIME
);
GO
	
IF OBJECT_ID('bronze.erp_cust', 'U') IS NOT NULL
BEGIN
	DROP TABLE  bronze.erp_cust;  
END
GO
CREATE TABLE bronze.erp_cust (
	cid   NVARCHAR(50),
	bdate DATE,
	GEN   NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat', 'U') IS NOT NULL
BEGIN
	DROP TABLE  bronze.erp_px_cat;  
END
GO
CREATE TABLE bronze.erp_px_cat (
	id          NVARCHAR(50),
	cat         NVARCHAR(50),
	subcat      NVARCHAR(50),
	maintenance NVARCHAR(50)
	
);
GO

IF OBJECT_ID('bronze.erp_loc ', 'U') IS NOT NULL
BEGIN
	DROP TABLE  bronze.erp_loc;
END
GO
CREATE TABLE bronze.erp_loc (
	cid   NVARCHAR(50),
	cntry NVARCHAR(50)	
);

/*===============================================================================
3. Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================*/
TRUNCATE TABLE bronze.crm_cust_info  
BULK INSERT bronze.crm_cust_info 
FROM 'D:\Documents\work\BA\Project\Data with Baraa\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
--Bulk insert into temporary sales_deatils table
TRUNCATE TABLE bronze.crm_sales_details_staging
BULK INSERT bronze.crm_sales_details_staging
FROM 'D:\Documents\work\BA\Project\Data with Baraa\sql-data-warehouse-project\datasets\source_crm\sales_details1.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
--Transform data from staging table to main table: sales_details
INSERT INTO bronze.crm_sales_details
(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_sales, sls_quantity, sls_price)
SELECT
    sls_ord_num,
    sls_prd_key,
    TRY_CAST(sls_cust_id AS INT),
    TRY_CAST(sls_order_dt AS INT),
    TRY_CAST(sls_ship_dt AS INT),
    TRY_CAST(sls_sales AS INT),
    TRY_CAST(sls_quantity AS INT),
    TRY_CAST(REPLACE(sls_price, ',', '') AS INT)  -- delete delimiter, conver into INT
FROM bronze.crm_sales_details_staging;

TRUNCATE TABLE bronze.crm_prd_info 
BULK INSERT bronze.crm_prd_info 
FROM 'D:\Documents\work\BA\Project\Data with Baraa\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.erp_cust
BULK INSERT bronze.erp_cust
FROM 'D:\Documents\work\BA\Project\Data with Baraa\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.erp_loc
BULK INSERT bronze.erp_loc
FROM 'D:\Documents\work\BA\Project\Data with Baraa\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

TRUNCATE TABLE bronze.erp_px_cat
BULK INSERT bronze.erp_px_cat
FROM 'D:\Documents\work\BA\Project\Data with Baraa\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

