
/*=============================================================
Create Database and Schemas
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
DDL Script: Create Bronze Tables
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
	subcat      INT,
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


