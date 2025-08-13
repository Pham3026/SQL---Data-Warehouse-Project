/*
===============================================================================
1. DDL Script: Create Silver Tables
2. Stored Procedure: Load Silver Layer (Bronze -> Silver)
  Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
===============================================================================
*/
===============================================================================
1. DDL Script: Create Silver Tables
===============================================================================
*/
IF OBJECT_ID('sliver.crm_cust_info', 'U') IS NOT NULL
BEGIN
	DROP TABLE sliver.crm_cust_info;  
END
GO
CREATE TABLE sliver.crm_cust_info (
	cst_id              INT,
	cst_key             NVARCHAR(50),
	cst_firstname       NVARCHAR(50),
	cst_lastname        NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr            NVARCHAR(50),
	cst_create_date     DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
	);
GO
	

IF OBJECT_ID('sliver.crm_sales_details', 'U') IS NOT NULL
BEGIN
	DROP TABLE sliver.crm_sales_details;  
END
GO
CREATE TABLE sliver.crm_sales_details (
	sls_ord_num   NVARCHAR(50),
	sls_prd_key   NVARCHAR(50),
	sls_cust_id   INT,
	sls_order_dt  INT,
	sls_ship_dt   INT,
	sls_sales     INT,
	sls_quantity  INT,
	sls_price     INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()

);
GO
	
IF OBJECT_ID('sliver.crm_prd_info', 'U') IS NOT NULL
BEGIN
	DROP TABLE  sliver.crm_prd_info;  
END
GO
CREATE TABLE sliver.crm_prd_info (
	prd_id       INT,
	prd_key      NVARCHAR(50),
	prd_nm       NVARCHAR(50),
	prd_cost     INT,
	prd_line     NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt   DATETIME,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
	
IF OBJECT_ID('sliver.erp_cust', 'U') IS NOT NULL
BEGIN
	DROP TABLE  sliver.erp_cust;  
END
GO
CREATE TABLE sliver.erp_cust (
	cid   NVARCHAR(50),
	bdate DATE,
	GEN   NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('sliver.erp_px_cat', 'U') IS NOT NULL
BEGIN
	DROP TABLE  sliver.erp_px_cat;  
END
GO
CREATE TABLE sliver.erp_px_cat (
	id          NVARCHAR(50),
	cat         NVARCHAR(50),
	subcat      NVARCHAR(50),
	maintenance NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
	
);
GO

IF OBJECT_ID('sliver.erp_loc ', 'U') IS NOT NULL
BEGIN
	DROP TABLE  sliver.erp_loc;
END
GO
CREATE TABLE sliver.erp_loc (
	cid   NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
