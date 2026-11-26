-- Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Check Duplicate Customer IDS
SELECT customer_id,
COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*)>1;

-- Check customer IDs are actually used by accounts/ Customers without account
SELECT COUNT(*) AS customers_without_accounts
FROM customers c
LEFT JOIN accounts a
ON c.customer_id = a.customer_id 
WHERE a.customer_id IS NULL;

-- Customers who have multiple accounts top 10 
SELECT customer_id,
COUNT(*) AS account_count
FROM accounts
GROUP BY customer_id
HAVING COUNT(*)>1
ORDER BY account_count DESC 
LIMIT 10;

