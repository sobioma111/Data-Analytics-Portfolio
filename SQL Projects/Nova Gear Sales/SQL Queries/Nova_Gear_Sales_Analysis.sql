/* ============================================================
   NOVA GEAR SALES — SQL ANALYSIS PROJECT
   Database: nova_gear_sales
   Clean table: nova_gear_sales_clean

   Purpose:
   - Data cleaning and validation
   - Data quality checks
   - Business analysis
   - Preparation of insights used in Power BI
   ============================================================ */


-- ============================================================
-- 1. DATABASE AND TABLE
-- ============================================================

USE nova_gear_sales;

-- Inspect the original table
SELECT *
FROM nova_gear_sales
LIMIT 10;

-- Check total number of rows
SELECT COUNT(*) AS total_rows
FROM nova_gear_sales;


-- ============================================================
-- 2. DATA QUALITY CHECKS
-- ============================================================

-- Check for NULL values in important fields
SELECT
    SUM(order_id IS NULL) AS null_order_id,
    SUM(order_date IS NULL) AS null_order_date,
    SUM(product_name IS NULL) AS null_product_name,
    SUM(product_category IS NULL) AS null_product_category,
    SUM(country IS NULL) AS null_country,
    SUM(quantity IS NULL) AS null_quantity,
    SUM(unit_price_usd IS NULL) AS null_unit_price,
    SUM(order_status IS NULL) AS null_order_status
FROM nova_gear_sales;


-- Check for genuinely blank product names
SELECT COUNT(*) AS blank_product_names
FROM nova_gear_sales
WHERE TRIM(COALESCE(product_name, '')) = '';


-- ============================================================
-- 3. TEXT CLEANING AND STANDARDIZATION
-- ============================================================

/*
Text fields were checked for unwanted leading and trailing
spaces and inconsistent/blank text values.

TRIM() was used during validation to identify values that
contained unnecessary whitespace.

Important text fields checked included:
    customer_name
    country
    city
    product_category
    product_name
    device_type
    payment_method
    order_status
*/

-- Check for leading/trailing spaces in customer names
SELECT COUNT(*) AS names_with_extra_spaces
FROM nova_gear_sales
WHERE customer_name <> TRIM(customer_name);

-- Check for leading/trailing spaces in product names
SELECT COUNT(*) AS products_with_extra_spaces
FROM nova_gear_sales
WHERE product_name <> TRIM(product_name);

-- Check for blank device types
SELECT COUNT(*) AS blank_device_type
FROM nova_gear_sales
WHERE TRIM(COALESCE(device_type, '')) = '';

-- Check for blank payment methods
SELECT COUNT(*) AS blank_payment_method
FROM nova_gear_sales
WHERE TRIM(COALESCE(payment_method, '')) = '';


-- ============================================================
-- 4. DATE CLEANING
-- ============================================================

/*
The imported order_date contained mixed date formats.

Examples included:
    01 01 2021
    13 January 2021
    01-26-2021

A temporary DATE column was created and the mixed formats
were converted into a standard DATE format.

The cleaning process was completed successfully:
    Invalid converted dates = 0
*/


/*
-- DOCUMENTATION OF THE CLEANING PROCESS

ALTER TABLE nova_gear_sales
ADD COLUMN order_date_new DATE;

UPDATE nova_gear_sales
SET order_date_new =
    CASE
        WHEN order_date REGEXP '^[0-9]{2} [A-Za-z]+ [0-9]{4}$'
            THEN STR_TO_DATE(order_date, '%d %M %Y')

        WHEN order_date REGEXP '^[0-9]{2} [0-9]{2} [0-9]{4}$'
            THEN STR_TO_DATE(order_date, '%d %m %Y')

        WHEN order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(order_date, '%m-%d-%Y')

        ELSE NULL
    END;

-- Verify invalid conversions
SELECT COUNT(*) AS invalid_dates
FROM nova_gear_sales
WHERE order_date_new IS NULL;

-- After verification, the old column was replaced with
-- the cleaned DATE column.
*/


-- ============================================================
-- 5. DUPLICATE CHECK
-- ============================================================

-- Total rows
SELECT COUNT(*) AS total_rows
FROM nova_gear_sales;

-- Distinct order IDs
SELECT COUNT(DISTINCT order_id) AS distinct_orders
FROM nova_gear_sales;


/*
Result:
    Total rows       = 9,869
    Distinct orders  = 9,721

This indicated 148 additional duplicate rows.
*/


-- Identify duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM nova_gear_sales
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


-- ============================================================
-- 6. BACKUP AND CLEAN TABLE
-- ============================================================

/*
A backup was created before removing duplicates.

CREATE TABLE nova_gear_sales_backup AS
SELECT *
FROM nova_gear_sales;

The backup contained 9,869 rows.
*/


/*
The clean table was created using DISTINCT.

CREATE TABLE nova_gear_sales_clean AS
SELECT DISTINCT *
FROM nova_gear_sales;
*/


-- Verify cleaned table
SELECT COUNT(*) AS clean_rows
FROM nova_gear_sales_clean;


-- Verify duplicate order IDs in clean table
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM nova_gear_sales_clean
GROUP BY order_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 7. FINAL DATASET VALIDATION
-- ============================================================

SELECT COUNT(*) AS total_clean_rows
FROM nova_gear_sales_clean;

SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM nova_gear_sales_clean;


-- ============================================================
-- 8. KEY BUSINESS KPIs
-- ============================================================

-- Total Revenue
SELECT
    ROUND(SUM(unit_price_usd * quantity), 2) AS total_revenue
FROM nova_gear_sales_clean;


-- Total Quantity Sold
SELECT
    SUM(quantity) AS total_quantity_sold
FROM nova_gear_sales_clean;


-- Average Order Value
SELECT
    ROUND(
        SUM(unit_price_usd * quantity)
        / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM nova_gear_sales_clean;


-- Total Unique Orders
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM nova_gear_sales_clean;


-- Total Customers
SELECT
    COUNT(DISTINCT customer_name) AS total_customers
FROM nova_gear_sales_clean;


-- ============================================================
-- 9. REVENUE BY PRODUCT CATEGORY
-- ============================================================

SELECT
    product_category,
    ROUND(SUM(unit_price_usd * quantity), 2) AS total_revenue
FROM nova_gear_sales_clean
GROUP BY product_category
ORDER BY total_revenue DESC;


-- ============================================================
-- 10. REVENUE BY COUNTRY
-- ============================================================

SELECT
    country,
    ROUND(SUM(unit_price_usd * quantity), 2) AS total_revenue
FROM nova_gear_sales_clean
GROUP BY country
ORDER BY total_revenue DESC;


-- ============================================================
-- 11. MONTHLY REVENUE
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    ROUND(SUM(unit_price_usd * quantity), 2) AS total_revenue
FROM nova_gear_sales_clean
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;


-- ============================================================
-- 12. REVENUE BY DEVICE
-- ============================================================

SELECT
    device_type,
    ROUND(SUM(unit_price_usd * quantity), 2) AS total_revenue
FROM nova_gear_sales_clean
GROUP BY device_type
ORDER BY total_revenue DESC;


-- ============================================================
-- 13. REVENUE BY PAYMENT METHOD
-- ============================================================

SELECT
    payment_method,
    ROUND(SUM(unit_price_usd * quantity), 2) AS total_revenue
FROM nova_gear_sales_clean
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- ============================================================
-- 14. REVENUE BY ORDER STATUS
-- ============================================================

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(unit_price_usd * quantity), 2) AS total_revenue
FROM nova_gear_sales_clean
GROUP BY order_status
ORDER BY total_revenue DESC;


-- ============================================================
-- 15. COMPLETED REVENUE
-- ============================================================

SELECT
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'Completed'
                THEN unit_price_usd * quantity
                ELSE 0
            END
        ),
        2
    ) AS completed_revenue
FROM nova_gear_sales_clean;


-- ============================================================
-- 16. REVENUE LEAKAGE
-- ============================================================

SELECT
    ROUND(
        SUM(
            CASE
                WHEN order_status IN ('Refunded', 'Cancelled')
                THEN unit_price_usd * quantity
                ELSE 0
            END
        ),
        2
    ) AS leakage_revenue
FROM nova_gear_sales_clean;


-- Leakage Rate
SELECT
    ROUND(
        100 *
        SUM(
            CASE
                WHEN order_status IN ('Refunded', 'Cancelled')
                THEN unit_price_usd * quantity
                ELSE 0
            END
        )
        / SUM(unit_price_usd * quantity),
        2
    ) AS leakage_rate_percent
FROM nova_gear_sales_clean;


-- ============================================================
-- 17. TOP 10 PRODUCTS BY REVENUE
-- ============================================================

SELECT
    product_name,
    ROUND(SUM(unit_price_usd * quantity), 2) AS total_revenue
FROM nova_gear_sales_clean
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 18. TROUBLESHOOTING & SQL CORRECTIONS
-- ============================================================

/*
--------------------------------------------------------------
ISSUE 1 — MIXED DATE FORMATS
--------------------------------------------------------------

Problem:
The imported order_date values were not stored in one
consistent date format.

Examples:
    01 01 2021
    13 January 2021
    01-26-2021

Correction:
A temporary DATE column was created and STR_TO_DATE()
was used with the appropriate format for each pattern.

Validation:
The final check returned 0 invalid converted dates.
*/


/*
--------------------------------------------------------------
ISSUE 2 — DUPLICATE RECORDS
--------------------------------------------------------------

Initial check:

SELECT COUNT(*) FROM nova_gear_sales;

Returned:
    9,869 rows

But:

SELECT COUNT(DISTINCT order_id)
FROM nova_gear_sales;

Returned:
    9,721 unique orders.

Correction:
The duplicate records were investigated and a clean table
was created using:

SELECT DISTINCT *

The resulting clean dataset contained:
    9,721 rows
*/


/*
--------------------------------------------------------------
ISSUE 3 — APPARENT BLANK PRODUCT NAMES
--------------------------------------------------------------

An initial blank check appeared to indicate 70 blank
product names.

Instead of assuming those records were actually blank,
a stronger validation was performed using TRIM,
COALESCE, LENGTH and HEX.

The investigation showed that there were no genuine
NULL, empty or whitespace-only product names.

Lesson:
Always validate unexpected query results before changing
the dataset.
*/


/*
--------------------------------------------------------------
ISSUE 4 — IMPORT/MAPPING PROBLEM
--------------------------------------------------------------

During the initial MySQL import, some columns were mapped
incorrectly.

Examples identified during the import:
    Quantity → device_type
    Payment Method → order_status

Correction:
The column mappings were reviewed and corrected before
continuing with the analysis.

Lesson:
Validate column mapping immediately after importing data.
*/


-- ============================================================
-- 19. FINAL PROJECT VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    
    
    COUNT(DISTINCT order_id) AS unique_orders,
    ROUND(SUM(unit_price_usd * quantity), 2) AS total_revenue
FROM nova_gear_sales_clean;


/* ============================================================
   END OF NOVA GEAR SALES SQL ANALYSIS
   ============================================================ */
   
