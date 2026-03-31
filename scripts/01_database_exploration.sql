/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Used Tables:
    - INFORMATION_SCHEMA.TABLES (List of all tables)
    - INFORMATION_SCHEMA.COLUMNS (Detailed column metadata)
===============================================================================
*/

-- 1. Retrieve a list of all user-defined tables in the 'public' schema

SELECT 
    table_catalog, 
    table_schema, 
    table_name, 
    table_type
FROM information_schema.tables
WHERE table_schema = 'public' 
ORDER BY table_name ASC;

-- 2. Retrieve detailed metadata for columns in a specific table (dim_customers)
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    character_maximum_length,
    column_default,
    ordinal_position -- The order in which columns were defined
FROM information_schema.columns
WHERE table_name = 'dim_customers' 
  AND table_schema = 'public'
ORDER BY ordinal_position ASC;