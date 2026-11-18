/*
===============================================================================
Procedure: bronze.load_bronze
Purpose  : Refreshes the Bronze Layer by loading raw CRM and ERP data from CSV files.
           Consolidates all table-loading operations into one reusable procedure,
           allowing the entire Bronze Layer to be refreshed with a single command.

Features : TRY...CATCH error handling, execution progress messages, and individual
           table-level and overall batch execution-time tracking.

Execution: EXEC bronze.load_bronze;
===============================================================================
*/
USE [DataWarehouse];
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE @start_time DATETIME, 
            @end_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '==========================================================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '==========================================================================================';

        -- CRM: Customer Information
        PRINT '__________________________________________________________________________________________';
        PRINT 'Loading CRM Tables';
        PRINT '__________________________________________________________________________________________';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\gayatri\Documents\sql practical\Data Warehouse Project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' 
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) 
            + ' seconds';


        -- CRM: Product Information
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\gayatri\Documents\sql practical\Data Warehouse Project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- CRM: Sales Details
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\gayatri\Documents\sql practical\Data Warehouse Project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- ERP: Customer Information
        PRINT '__________________________________________________________________________________________';
        PRINT 'Loading ERP Tables';
        PRINT '__________________________________________________________________________________________';

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\gayatri\Documents\sql practical\Data Warehouse Project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- ERP: Location Information
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\gayatri\Documents\sql practical\Data Warehouse Project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- ERP: Product Category Information
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\gayatri\Documents\sql practical\Data Warehouse Project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        PRINT '==========================================================================================';
        PRINT 'Bronze Layer Loading Completed Successfully';
        PRINT '==========================================================================================';
        SET @batch_end_time = GETDATE();
        PRINT '>> Total Batch Load Duration ' + CAST(DATEDIFF( second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'; 
    END TRY

    BEGIN CATCH

        PRINT '==========================================================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(20));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(20));
        PRINT '==========================================================================================';

        THROW;

    END CATCH

END;

/*
===============================================================================
Implementation Details:
===============================================================================
- Centralized CRM and ERP data-loading operations into a single stored procedure
  to simplify and standardize the Bronze Layer refresh process.
- Used TRUNCATE TABLE and BULK INSERT to replace existing data with fresh source data.
- Implemented PRINT statements to provide visibility into the execution process.
- Added TRY...CATCH error handling to capture and propagate runtime errors.
- Incorporated table-level and batch-level execution-time tracking to monitor
  ETL performance and identify potential bottlenecks.
===============================================================================
*/
