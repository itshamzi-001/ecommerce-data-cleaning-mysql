create database Project;
use Project;
select * from ecommerce_dirty_data;



-- Remove leading/trailing spaces
update ecommerce_dirty_data
set 	customer_name = trim(customer_name),
		city = trim(city),
		payment_method = TRIM(payment_method);
   
-- Convert all text to proper case
UPDATE ecommerce_dirty_data
SET customer_name = CONCAT(
    UPPER(SUBSTRING(customer_name,1,1)),  
    LOWER(SUBSTRING(customer_name,2))      
);

-- Handle missing values
UPDATE ecommerce_dirty_data
SET category = 'Unknown'
WHERE category IS NULL OR category = '';


-- Convert quantity, price, total_amount to numeric
UPDATE ecommerce_dirty_data
SET price = NULL
WHERE price REGEXP '[^0-9.]' OR price = '';

UPDATE ecommerce_dirty_data
SET quantity = NULL
WHERE quantity REGEXP '[^0-9]' OR quantity = '';



-- Add new numeric columns
ALTER TABLE ecommerce_dirty_data
ADD COLUMN clean_price DECIMAL(10,2),
ADD COLUMN clean_quantity INT,
ADD COLUMN clean_total DECIMAL(10,2);

-- Copy clean values
UPDATE ecommerce_dirty_data
SET clean_price = CAST(price AS DECIMAL(10,2)),
    clean_quantity = CAST(quantity AS UNSIGNED),
    clean_total = clean_price * clean_quantity;

-- Fix Date Format
alter table  ecommerce_dirty_data
add column clean_order_date DATE;

UPDATE ecommerce_dirty_data
SET clean_order_date = 
    CASE
        WHEN order_date LIKE '%/%/%' THEN STR_TO_DATE(order_date, '%d/%m/%Y')
        WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN STR_TO_DATE(order_date, '%Y-%m-%d')
        WHEN order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(order_date, '%m-%d-%Y')
        ELSE NULL
    END;

-- City names
update ecommerce_dirty_data
set city = 
	case
		when city in ('lahor' , 'lahor ') then 'Lahore'
		WHEN city IN ('karacchi') THEN 'Karachi'
		WHEN city IN ('islmabad') THEN 'Islamabad'
        when city in ('Unknown') Then ''
        else city 
	end;
    
UPDATE ecommerce_dirty_data
SET category = 
CASE
    WHEN category IN ('eletronics') THEN 'Electronics'
    WHEN category IN ('Applinces') THEN 'Appliances'
    ELSE category
END;

UPDATE ecommerce_dirty_data
SET delivery_status =
 CASE
    WHEN delivery_status IN ('delievered') THEN 'Delivered'
    WHEN delivery_status IN ('pendng') THEN 'Pending'
    ELSE delivery_status
END;

    

SELECT order_id, customer_name, email
FROM ecommerce_dirty_data
WHERE email NOT LIKE '%@%.%' OR email IS NULL OR email = '';

UPDATE ecommerce_dirty_data
SET email = REPLACE(email, '@gmailcom', '@gmail.com');

UPDATE ecommerce_dirty_data
SET email = REPLACE(email, '@gmial.com', '@gmail.com');

DELETE FROM ecommerce_dirty_data
WHERE email NOT LIKE '%@%.%' OR email IS NULL OR email = '';

UPDATE ecommerce_dirty_data
SET email = NULL
WHERE email NOT LIKE '%@%.%';

SELECT COUNT(*) AS invalid_emails
FROM ecommerce_dirty_data
WHERE email NOT LIKE '%@%.%' OR email IS NULL OR email = '';

DELETE FROM ecommerce_dirty_data
WHERE order_id IS NULL
   OR order_id IN (
       SELECT order_id
       FROM (
           SELECT order_id
           FROM ecommerce_dirty_data
           GROUP BY order_id
           HAVING COUNT(*) > 1
       ) AS dup
   );



update ecommerce_dirty_data
set order_id = round(order_id , 0);

-- Recalculate Totals

UPDATE ecommerce_dirty_data
SET clean_total = clean_price * clean_quantity
WHERE clean_total IS NULL OR clean_total <= 0;

select * from ecommerce_dirty_data;
