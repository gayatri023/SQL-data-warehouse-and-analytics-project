
/*
===============================================================================
DATABASE INITIALIZATION: DATAWAREHOUSE
===============================================================================

Purpose:        Create and initialize the DataWarehouse database.

Description:
    This script sets up the initial database environment for the data
    warehouse project by creating a new database and organizing its
    objects into three schemas based on the Medallion Architecture.

Operations:
    1. Check if the DataWarehouse database already exists.
    2. Drop the existing database, if present.
    3. Create a fresh DataWarehouse database.
    4. Create the Bronze, Silver, and Gold schemas.
    5. Verify that all schemas have been created successfully.

Schema Organization:
    Bronze  - Stores raw data from source systems.
    Silver  - Stores cleaned and transformed data.
    Gold    - Stores business-ready data for reporting and analytics.

WARNING:
    Running this script will permanently delete the existing DataWarehouse
    database, including all its data, tables, and other database objects.

    Ensure that any required data is backed up before execution.

===============================================================================
*/


-- =============================================================================
-- STEP 1: DROP AND RECREATE DATABASE
-- =============================================================================

-- Switch to the master database to manage the DataWarehouse database.
USE [master];
GO

-- Check if the DataWarehouse database already exists.
IF DB_ID('DataWarehouse') IS NOT NULL
BEGIN
    -- Disconnect active sessions and roll back unfinished transactions
    -- to ensure that the database can be dropped.
    ALTER DATABASE [DataWarehouse]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    -- Drop the existing database and all its contents.
    DROP DATABASE [DataWarehouse];
END;
GO

-- Create a fresh DataWarehouse database.
CREATE DATABASE [DataWarehouse];
GO


-- =============================================================================
-- STEP 2: CREATE MEDALLION ARCHITECTURE SCHEMAS
-- =============================================================================

-- Set the current database context to DataWarehouse.
USE [DataWarehouse];
GO

-- Create the Bronze schema for storing raw source data.
CREATE SCHEMA [bronze];
GO

-- Create the Silver schema for storing cleaned and transformed data.
CREATE SCHEMA [silver];
GO

-- Create the Gold schema for storing business-ready data.
CREATE SCHEMA [gold];
GO


-- =============================================================================
-- STEP 3: VERIFY DATABASE SCHEMAS
-- =============================================================================

-- Retrieve the schemas created in the DataWarehouse database.
SELECT
    name AS schema_name,
    schema_id,
    USER_NAME(principal_id) AS schema_owner
FROM sys.schemas
WHERE name IN ('bronze', 'silver', 'gold')
ORDER BY
    CASE name
        WHEN 'bronze' THEN 1
        WHEN 'silver' THEN 2
        WHEN 'gold'   THEN 3
    END;
GO
