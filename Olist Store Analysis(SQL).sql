Create database olist_database;
use olist_database;

create table olist_customers_dataset(
customer_id text,
customer_unique_id text,
customer_zip_code_prefix int,
customer_city text,
customer_state text
);

SHOW VARIABLES LIKE "secure_file_priv";

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_customers_dataset.csv' 
into table olist_customers_dataset 
fields terminated by ',' 
optionally enclosed by '"' 
lines terminated by '\n' 
ignore 1 rows;

select * from olist_customers_dataset;

CREATE TABLE olist_orders_dataset (
    order_id VARCHAR(255) NOT NULL,
    customer_id VARCHAR(255) NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    order_purchase_timestamp DATETIME NOT NULL,
    order_approved_at text,
    order_delivered_carrier_date text,
    order_delivered_customer_date text,
    order_estimated_delivery_date DATETIME,
    PRIMARY KEY (order_id)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from olist_orders_dataset;

CREATE TABLE olist_order_payments_dataset (
    order_id VARCHAR(255) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(50) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DOUBLE NOT NULL
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table olist_order_payments_dataset;

select * from olist_order_payments_dataset;

CREATE TABLE olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(10) NOT NULL,
    geolocation_lat DOUBLE NOT NULL,
    geolocation_lng DOUBLE NOT NULL,
    geolocation_city VARCHAR(255) NOT NULL,
    geolocation_state VARCHAR(2) NOT NULL);
    
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from olist_geolocation_dataset;
drop table olist_geolocation_dataset

 CREATE TABLE olist_order_items_dataset (
    order_id VARCHAR(255) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(255) NOT NULL,
    seller_id VARCHAR(255) NOT NULL,
    shipping_limit_date DATETIME NOT NULL,
    price DOUBLE NOT NULL,
    freight_value DOUBLE NOT NULL,
    PRIMARY KEY (order_id, order_item_id)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from olist_order_items_dataset;


CREATE TABLE olist_order_reviews_dataset (
    review_id VARCHAR(255) NOT NULL,
    order_id VARCHAR(255) NOT NULL,
    review_score int
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table olist_order_reviews_dataset;
select * from olist_order_reviews_dataset;


CREATE TABLE olist_sellers_dataset (
    seller_id varchar(255) PRIMARY KEY,
    seller_zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_sellers_dataset.csv'
INTO TABLE olist_sellers_dataset 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from olist_sellers_dataset;

CREATE TABLE olist_products_dataset (
  product_id TEXT,
  product_category_name TEXT,
  product_name_length text NULL DEFAULT NULL,
  product_description_length text,
  product_photos_qty text,
  product_weight_g text,
  product_length_cm text,
  product_height_cm text,
  product_width_cm text
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_products_dataset.csv'
INTO TABLE olist_products_dataset 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from olist_products_dataset;

CREATE TABLE product_category_name_translation (
 product_category_name Text,
 product_category_name_english text
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from product_category_name_translation;
---------------------------------------------------------------------------------------------
select * from olist_customers_dataset;
select * from olist_orders_dataset;
select * from olist_order_payments_dataset;
select * from olist_geolocation_dataset;
select * from olist_order_items_dataset;
select * from olist_order_reviews_dataset;
select * from olist_sellers_dataset;
select * from olist_products_dataset;
select * from product_category_name_translation;

show tables;
------------------------------------------------------------------------------------------------------
select count(*) as customer from olist_customers_dataset;                
select count(*) as orders from olist_orders_dataset;                       
select count(*) as order_items from olist_order_items_dataset; 		        
select count(*) as order_payments from olist_order_payments_dataset;       
select count(*) as order_reviews from olist_order_reviews_dataset;          
select count(*) as products from olist_products_dataset;                    
select count(*) as sellers  from olist_sellers_dataset;                     
select count(*) as geolocation from olist_geolocation_dataset;           
select count(*) as Product_category from product_category_name_translation;

--------------------------------------------------------------------------------------------------------------------------------

-- KPI 1 (Weekday vs weekend (order_purchases_timestamp) payment_statistics)--
  
    SELECT 
    IF(WEEKDAY(olist_orders_dataset.order_purchase_timestamp) IN (5, 6), 'Weekend', 'Weekday') AS day_type, 
    SUM(olist_order_payments_dataset.payment_value) AS total_payment
FROM 
    olist_orders_dataset 
    INNER JOIN olist_order_payments_dataset ON olist_orders_dataset.order_id = olist_order_payments_dataset.order_id
GROUP BY 
    day_type;

    
-- KPI 2 (number of order with review score 5 and payment type as credit_card)--

select count(r.order_id), r.review_score, p. payment_type
from olist_order_reviews_dataset r  join olist_order_payments_dataset p on r.order_id = p.order_id
where review_score = 5 and payment_type = "credit_card";


-- KPI 3 (Average number of days taken for order_delivered_customer_date for pet_shop)--

select
 p.product_category_name,
ROUND(AVG(DATEDIFF(od.order_delivered_customer_date,od.order_purchase_timestamp))) AS AVG_Delivery_Days
 FROM olist_products_dataset p
 INNER JOIN olist_order_items_dataset  oi  ON p.product_id = oi.product_id
 INNER JOIN olist_orders_dataset od ON oi.order_id = od.order_id
 WHERE p.product_category_name = "pet_shop"
 GROUP BY
  p.product_category_name;
  
  select round(avg(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)),2) as avg_delivery_days
from olist_orders_dataset as o
join olist_order_items_dataset as oi on o.order_id = oi.order_id
join olist_products_dataset as p on oi.product_id = p.product_id
where product_category_name = 'pet_shop';


  
 
-- KPI 4 (Average price and payment values from customers of sao paulo city)--
SELECT 
  c.customer_city,
ROUND(AVG(i.price)) AS Average_Price,
ROUND(AVG(p.payment_value)) AS Average_Payment
FROM olist_customers_dataset c 
INNER JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
INNER JOIN olist_order_items_dataset i ON o.order_id = i.order_id
INNER JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE c.customer_city = "sao paulo"
GROUP BY c.customer_city;

-- KPI 5 (Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores)---

SELECT review_score, AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_shipping_days
FROM olist_orders_dataset o
INNER JOIN olist_order_reviews_dataset r
  ON o.order_id = r.order_id
GROUP BY review_score 
order by (review_score) desc;


Show variables like 'net%timeout%';

SET GLOBAL net_read_timeout=30;

SET GLOBAL net_write_timeout=60;

select @@global.net_read_timeout, @@global.net_write_timeout;



