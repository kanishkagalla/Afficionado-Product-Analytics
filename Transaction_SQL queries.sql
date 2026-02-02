SELECT * FROM transaction;

ALTER TABLE transaction
ADD COLUMN "revenue" INTEGER;

UPDATE transaction
SET "" = "transaction_qty" * "unit_price";


--High-volume products with low revenue contribution
--Goal: Find products sold in large quantities but generating little revenue.

SELECT 
    product_id,
    product_category,
    product_type,
    SUM(transaction_qty) AS total_qty,
   ROUND(SUM(transaction_qty * unit_price)::numeric,2) AS total_revenue
FROM transaction
GROUP BY product_id, product_category, product_type
ORDER BY total_qty DESC, total_revenue ASC;



-- High-priced products with low sales frequency
--Goal: Identify expensive items that are rarely sold.


SELECT product_id, product_category, product_type, unit_price, COUNT(*) AS sales_count
FROM transaction
GROUP BY product_id, unit_price, product_category,product_type
ORDER BY unit_price DESC, sales_count ASC;



--Overcrowded menus that slow service
--Goal: Detect categories with too many product variants.

SELECT product_category, COUNT(DISTINCT product_id) AS item_count
FROM transaction
GROUP BY product_category
ORDER BY item_count DESC;



--Which products customers prefer
--Goal: Find most frequently purchased products.


SELECT product_id, product_category, product_type, COUNT(*) AS purchase_count
FROM transaction
GROUP BY product_id, product_category, product_type
ORDER BY purchase_count DESC
LIMIT 10;


--Which products generate the most revenue
--Goal: Identify top revenue-generating products.


SELECT product_id, product_category, product_type, ROUND(SUM(transaction_qty * unit_price)::numeric,2) AS total_revenue
FROM transaction
GROUP BY product_id, product_category, product_type
ORDER BY total_revenue DESC
LIMIT 10;


--Top-selling and least-selling product

-- Top-selling
SELECT product_id,  product_category, product_type, SUM(transaction_qty) AS total_qty
FROM transaction
GROUP BY product_id, product_category, product_type
ORDER BY total_qty DESC
LIMIT 10;

-- Least-selling
SELECT product_id, product_category, product_type, SUM(transaction_qty) AS total_qty
FROM transaction
GROUP BY product_id, product_category, product_type
ORDER BY total_qty ASC
LIMIT 10;



--Low-impact or underperforming items

SELECT product_id, product_category, product_type, ROUND(SUM(transaction_qty * unit_price)::NUMERIC,2) AS revenue
FROM transaction
GROUP BY product_id, product_category, product_type
ORDER BY revenue asc;


--Product popularity vs profitability

SELECT product_id, product_category, product_type,
       COUNT(*) AS popularity,
       SUM(transaction_qty * unit_price) AS profitability
FROM transaction
GROUP BY product_id, product_category, product_type
ORDER BY popularity DESC, profitability DESC;


--Revenue concentration across the menu


SELECT 
    product_id,
    SUM(revenue) AS reven,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (), 2) AS revenue_pct
FROM transaction
GROUP BY product_id
ORDER BY revenue_pct DESC;
















