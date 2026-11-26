-- MERCHANT ANALYSIS 
-- 1 Total Merchants
SELECT 
COUNT(*) AS total_merchants
From merchants;

-- 2 Check Duplicate Merchant IDs
SELECT merchant_id,
COUNT(*) AS duplicate_count
FROM merchants
GROUP BY merchant_id
HAVING COUNT(*)>1;

-- 3 Merchants By City
SELECT city,
COUNT(*) AS merchant_count
FROM merchants
GROUP BY city
ORDER BY merchant_count DESC;

-- 4 Top 10 Merchants By Transaction Amount
SELECT m.merchant_id, m.merchant_name,
ROUND(SUM(t.amount_usd),2) AS total_transaction_amount
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id 
GROUP BY m.merchant_id, m.merchant_name
ORDER BY total_transaction_amount DESC
LIMIT 10;

-- 5 Top 10 Merchants by Transaction Count
SELECT m.merchant_id, m.merchant_name,
COUNT(t.transaction_id) AS transaction_count
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_id, m.merchant_name
ORDER BY transaction_count DESC 
LIMIT 10;

-- 6 Average Transaction Amount by Merchant
SELECT m.merchant_id, m.merchant_name,
ROUND(AVG(t.amount_usd),2) AS average_transaction_amount
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_id, m.merchant_name
ORDER BY average_transaction_amount DESC
LIMIT 10;