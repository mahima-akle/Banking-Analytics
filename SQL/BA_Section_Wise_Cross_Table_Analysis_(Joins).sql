-- CROSS TABLE ANALYSIS
--SECTION 1 (CUSTOMER & ACCOUNT ANALYSIS)
-- 1 CUSTOMER ACCOUNT OWNERSHIP ANALYSIS
WITH customer_accounts AS (
SELECT customer_id,
COUNT(*) AS account_count
FROM accounts
GROUP BY customer_id
)
SELECT 
(SELECT COUNT(*) FROM customers) AS total_customers,
COUNT(*) AS customers_with_accounts,
(SELECT COUNT(*) FROM customers) - COUNT(*) AS customers_without_accounts,
ROUND(AVG(account_count),2) AS avg_accounts_per_customer,
MAX(account_count) AS max_accounts_per_customer, 
MIN(account_count) AS min_accounts_per_customer
FROM customer_accounts;

-- 2 CUSTOMER TRANSACTION ACTIVITY ANALYSIS 
-- connect Customers → Accounts → Transactions
WITH customer_transactions AS (
SELECT a.customer_id,
COUNT(t.transaction_id) AS transaction_count
FROM accounts a
LEFT JOIN transactions t
ON a.account_id = t.account_id
GROUP BY a.customer_id
)
SELECT 
COUNT(*) AS customers_with_accounts,
COUNT(CASE WHEN transaction_count > 0 THEN 1 END) AS customers_with_transactions,
COUNT(CASE WHEN transaction_count = 0 THEN 1 END) AS customers_without_transactions,
ROUND(AVG(transaction_count),2) AS avg_transaction_per_customer,
MAX(transaction_count) AS max_transaction_per_customer,
MIN(transaction_count) AS min_transaction_per_customer
FROM customer_transactions;

-- 3 CUSTOMER TRANSACTION VALUE ANALYSIS
-- analyze how much money each customer is transacting, rather than just how many transactions they make.
WITH customer_transaction_value AS (
SELECT a.customer_id,
COUNT(t.transaction_id) AS transaction_count,
SUM(t.amount_usd) AS total_transaction_value
FROM accounts a
INNER JOIN transactions t
ON a.account_id = t.account_id
GROUP BY a.customer_id
)
SELECT
COUNT(*) AS customer_with_transactions,
SUM(transaction_count) AS total_transactions,
ROUND(SUM(total_transaction_value),2) AS total_transaction_value,
ROUND(AVG(total_transaction_value),2) AS avg_transaction_value_per_customer,
ROUND(MAX(total_transaction_value),2) AS max_transaction_value_per_customer,
ROUND(MIN(total_transaction_value),2) AS min_transaction_value_per_customer
FROM customer_transaction_value;

-- 13 CUSTOMER CREDIT SCORE ANALYSIS
SELECT 
COUNT(*) AS total_customers,
ROUND(AVG(credit_score),2) AS avg_credit_score,
MIN(credit_score) AS min_credit_score,
MAX(credit_score) AS max_credit_score,
COUNT(*) FILTER (WHERE credit_score IS NULL) AS missing_credit_scores
FROM customers;

-- 14 CREDIT SCORE DISTRIBUTION
SELECT 
CASE 
WHEN credit_score < 500 THEN 'Poor'
WHEN credit_score < 600 THEN 'Fair'
WHEN credit_score < 700 THEN 'Good'
WHEN credit_score < 800 THEN 'Very Good'
ELSE 'Excellent'
END AS credit_category,
COUNT(*) AS customer_count
FROM customers
GROUP BY credit_category
ORDER BY MIN(credit_score);

-- 15 CUSTOMER CREATION TREND
SELECT
EXTRACT(YEAR FROM created_at) AS customer_year,
COUNT(*) AS customer_count
FROM customers
GROUP BY customer_year
ORDER BY customer_year;

-- 16 ACCOUNT TYPE ANALYSIS
SELECT account_type,
COUNT(*) AS account_count,
ROUND(SUM(balance_usd),2) AS total_balance,
ROUND(AVG(balance_usd),2) AS avg_balance,
ROUND(MIN(balance_usd),2) AS min_balance,
ROUND(MAX(balance_usd),2) AS max_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;

--SECTION 2 (CARD ANALYSIS)
-- 6 CARD CUSTOMER TRANSACTION ANALYSIS
-- Customers → Accounts → Cards → Transactions
WITH card_customers AS (
SELECT a.customer_id,
COUNT(DISTINCT c.card_id) AS card_count
FROM accounts a
INNER JOIN cards c 
ON a.account_id = c.account_id
GROUP BY a.customer_id
),
customer_transactions AS (
SELECT a.customer_id,
COUNT(t.transaction_id) AS transaction_count,
SUM(t.amount_usd) AS transaction_value
FROM accounts a 
INNER JOIN transactions t
ON a.account_id = t.account_id
GROUP BY a.customer_id
)
SELECT
COUNT(*) AS customers_with_cards,
COUNT(ct.customer_id) AS card_customers_with_transactions,
SUM(cc.card_count) AS total_cards,
SUM(ct.transaction_count) AS total_transactions,
ROUND(SUM(ct.transaction_value),2) AS total_transaction_value,
ROUND(AVG(ct.transaction_value),2) AS avg_transaction_value_per_card_customer
FROM card_customers cc
LEFT JOIN customer_transactions ct
ON cc.customer_id = ct.customer_id;

-- SECTION 3 (TRANSACTION ANALYSIS)
-- 17 TRANSACTION ANALYSIS
SELECT
COUNT(*) AS total_transactions,
ROUND(SUM(amount_usd),2) AS total_transaction_value_usd,
ROUND(AVG(amount_usd),2) AS avg_transaction_amount_usd,
ROUND(MIN(amount_usd),2) AS minimum_transaction_amount_usd,
ROUND(MAX(amount_usd),2) AS maximum_transaction_amount_usd,
MIN(transaction_date) AS first_transaction_date,
Max(transaction_date) AS last_transaction_date
FROM transactions;

-- 18 TRANSACTION TREND ANALYSIS-YEARLY TRANSACTION VOLUMN AND TRANSACTION VALUE
-- or yearly transaction trend analysis we can say 
SELECT 
EXTRACT(YEAR FROM transaction_date) AS transaction_year,
COUNT(*) AS total_transactions,
ROUND(SUM(amount_usd),2) AS total_transaction_value_usd,
ROUND(AVG(amount_usd),2) AS avg_transaction_amount_usd
FROM transactions
GROUP BY EXTRACT(YEAR FROM transaction_date)
ORDER BY transaction_year;

-- 19 MONTHKY TRANSACTION ANALYSIS
SELECT
EXTRACT(MONTH FROM transaction_date) AS transaction_month,
TO_CHAR(transaction_date,'Month') AS month_name,
COUNT(*) AS total_transactions,
ROUND(SUM(amount_usd),2) AS total_transaction_value_usd,
ROUND(AVG(amount_usd),2) AS average_transaction_amount_usd
FROM transactions
GROUP BY
EXTRACT(MONTH FROM transaction_date),
TO_CHAR(transaction_date, 'Month')
ORDER BY transaction_month;

-- 20 TRANSACTION ANALYSIS BY ACCOUNT TYPE
SELECT a.account_type,
COUNT(t.transaction_id) AS total_transactions,
ROUND(SUM(t.amount_usd),2) AS total_transaction_value_usd,
ROUND(AVG(t.amount_usd),2) AS average_transaction_amount_usd,
COUNT(DISTINCT a.account_id) AS active_accounts
FROM accounts a 
JOIN transactions t
ON a.account_id = t.account_id
GROUP BY a.account_type
ORDER BY total_transaction_value_usd DESC;

-- SECTION 4 (MERCHANT ANALYSIS)
-- 21 MERCHANT TRANSACTION ANALYSIS 
SELECT m.merchant_id, m.merchant_name,
COUNT(t.transaction_id) AS total_transactions,
ROUND(SUM(t.amount_usd),2) AS total_transaction_value_usd,
ROUND(AVG(t.amount_usd),2) AS avg_transaction_amount_usd
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
GROUP BY 
m.merchant_id,
m.merchant_name
ORDER BY total_transaction_value_usd DESC;

-- 22 TOP 10 MERCHANTS BY TRANSACTION VALUE 
SELECT m.merchant_id, m.merchant_name,
COUNT(t.transaction_id) AS total_transactions,
ROUND(SUM(t.amount_usd),2) AS total_transaction_value_usd,
ROUND(AVG(t.amount_usd),2) AS average_transaction_amount_usd
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_id, m.merchant_name
ORDER BY total_transaction_value_usd DESC
LIMIT 10;

-- 23 MERCHANT TRANSACTION VOLUME ANALYSIS
SELECT m.merchant_id, m.merchant_name,
COUNT(t.transaction_id) AS total_transactions,
ROUND(SUM(t.amount_usd),2) AS total_transaction_value_usd,
ROUND(AVG(t.amount_usd),2) AS average_transaction_amount_usd
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_id, m.merchant_name
ORDER BY total_transactions DESC
LIMIT 10;

-- 24 MERCHANT AVERAGE TRANSACTION ANALYSIS
SELECT m.merchant_id, m.merchant_name,
COUNT(t.transaction_id) AS total_transactions,
ROUND(SUM(t.amount_usd),2) AS total_transaction_value_usd,
ROUND(AVG(t.amount_usd),2) AS average_transaction_amount_usd
FROM merchants m
JOIN transactions t
ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_id, m.merchant_name
ORDER BY average_transaction_amount_usd DESC
LIMIT 10;

-- SECTION 5 (LOAN ANALYSIS)
-- 4 CUSTOMER LOAN ANALYSIS
-- Customers → Loans
WITH loan_summary AS (
SELECT 
COUNT(DISTINCT customer_id) AS customers_with_loans,
COUNT(loan_id) AS total_loans,
SUM(loan_amount) AS total_loan_value,
AVG(loan_amount) AS avg_loan_amount,
MAX(loan_amount) AS max_loan_amount,
MIN(loan_amount) AS min_loan_amount
FROM loans
)
SELECT
(SELECT COUNT(*)FROM customers) AS total_customers,customers_with_loans,
(SELECT COUNT(*) FROM customers) - customers_with_loans AS customers_without_loans,
total_loans,
ROUND(total_loan_value,2) AS total_loan_value,
ROUND(avg_loan_amount,2) AS avg_loan_amount,
ROUND(max_loan_amount,2) AS max_loan_amount,
ROUND(min_loan_amount,2) AS min_loan_amount
FROM loan_summary;

-- 5 LOAN CUSTOMER TRANSACTION ANALYSIS
-- Customers → Loans → Accounts → Transactions
-- The goal is to identify loan customers' transaction behavior.
-- We want to understand the transaction activity of customers who have loans.
WITH loan_customers AS (
SELECT customer_id,
SUM(loan_amount) AS total_loan_value
FROM loans
GROUP BY customer_id
),
customer_transactions AS (
SELECT a.customer_id,
COUNT(t.transaction_id) AS transaction_count,
SUM(t.amount_usd) AS transaction_value
FROM accounts a 
INNER JOIN transactions t
ON a.account_id = t.account_id
GROUP BY a.customer_id
)
SELECT 
COUNT(*) AS loan_customers,
COUNT(ct.customer_id) AS loan_customers_with_transactions,
ROUND(SUM(lc.total_loan_value),2) AS total_loan_value,
SUM(ct.transaction_count) AS total_transactions,
ROUND(SUM(ct.transaction_value),2) AS total_transaction_value,
ROUND(AVG(ct.transaction_value),2) AS avg_transaction_value_per_loan_customer
FROM loan_customers lc
LEFT JOIN customer_transactions ct
ON lc.customer_id = ct.customer_id;

-- 25 LOAN PORTFOLIO ANALYSIS
SELECT 
COUNT(*) AS total_loans,
ROUND(SUM(loan_amount),2) AS total_loan_value_usd,
ROUND(AVG(loan_amount),2) AS average_loan_amount_usd,
ROUND(MIN(loan_amount),2) AS minimum_loan_amount_usd,
ROUND(MAX(loan_amount),2) AS maximum_loan_amount_usd,
ROUND(AVG(interest_rate),2) AS average_interest_rate,
ROUND(MIN(interest_rate),2) AS minimum_interest_rate,
ROUND(MAX(interest_rate),2) AS maximum_interest_rate
FROM loans;

-- 26 LOAN ANALYSIS BY INTEREST RATE
SELECT 
CASE
WHEN interest_rate < 5 THEN 'Below 5%'
WHEN interest_rate < 8 THEN '5%-7.99%'
WHEN interest_rate < 11 THEN '8%-10.99%'
ELSE '11% and above'
END AS interest_rate_range,
COUNT(*) AS total_loans,
ROUND(SUM(loan_amount),2) AS total_loan_value_usd,
ROUND(AVG(loan_amount),2) AS average_loan_amount_usd,
ROUND(AVG(interest_rate),2) AS average_interest_rate
FROM loans
GROUP BY 
CASE 
WHEN interest_rate < 5 THEN 'Below 5%'
WHEN interest_rate < 8 THEN '5%-7.99%'
WHEN interest_rate < 11 THEN '8%-10.99%'
ELSE '11% and above'
END
ORDER BY MIN(interest_rate);

-- 27 LOAN ANALYSIS BY AMOUNT RANGE
SELECT
CASE 
WHEN loan_amount < 50000 THEN 'Below $50k'
WHEN loan_amount < 100000 THEN '$50k-$99.99k'
WHEN loan_amount < 200000 THEN '$100k-$199.99k'
ELSE '$200K and above'
END AS loan_amount_range,
COUNT(*) AS total_loans,
ROUND(SUM(loan_amount),2) AS total_loan_value_usd,
ROUND(AVG(loan_amount),2) AS average_loan_amount_usd
FROM loans
GROUP BY 
CASE
WHEN loan_amount < 50000 THEN 'Below $50k'
WHEN loan_amount < 100000 THEN '$50k-$99.99k'
WHEN loan_amount < 200000 THEN '$100k-$199.99k'
ELSE '$200K and above'
END
ORDER BY MIN(loan_amount);

-- 28 LOAN TREND ANALYSIS BY YEAR
SELECT 
EXTRACT(YEAR FROM start_date) AS loan_year,
COUNT(*) AS total_loans,
ROUND(SUM(loan_amount),2) AS total_loan_value_usd,
ROUND(AVG(loan_amount),2) AS average_loan_amount_usd,
ROUND(AVG(interest_rate),2) AS average_interest_rate
FROM loans
GROUP BY EXTRACT(YEAR FROM start_date)
ORDER BY loan_year;

-- 29 CUSTOMER LOAN EXPOSURE ANALYSIS
SELECT c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
COUNT(l.loan_id) AS total_loans,
ROUND(SUM(l.loan_amount),2) AS total_loan_exposure_usd,
ROUND(AVG(l.interest_rate),2) AS average_interest_rate
FROM customers c
JOIN loans l
ON c.customer_id = l.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name
ORDER BY total_loan_exposure_usd DESC
LIMIT 10;

-- SECTION 6 (BRANCH & GEOGRAPHIC ANALYSIS)
-- 7 BRANCH & CUSTOMER GEOGRAPHIC ANALYSIS
SELECT 
COUNT(*) AS total_branches,
COUNT(DISTINCT city) AS total_branch_cities,
MIN(city) AS sample_city,
MAX(city) AS sample_city_2
FROM branches;
-- 8 BRANCH DETAILS SAMPLE
SELECT 
branch_id,
branch_name,
manager_name,
city
FROM branches
LIMIT 10;

-- 9 BRANCH NETWORK ANALYSIS
SELECT
COUNT(*) AS total_branches,
COUNT(DISTINCT branch_name) AS unique_branch_names,
COUNT(DISTINCT manager_name) AS unique_managers,
COUNT(*) - COUNT(DISTINCT manager_name) AS duplicate_manager_assignments
FROM branches;

-- 10 DUPLICATE BRANCH NAMES INVESTIGATION
SELECT branch_name,
COUNT(*) AS branch_count
FROM branches
GROUP BY branch_name
HAVING COUNT(*)>1
ORDER BY branch_count DESC, branch_name;

-- 11 CUSTOMER GEOGRAPHIC DATA DISTRIBUTION/VALIDATION
SELECT
COUNT(*) AS total_customers,
COUNT(city) AS customers_with_city,
COUNT(*) - COUNT(city) AS customers_without_city,
COUNT(DISTINCT city) AS unique_customer_cities
FROM customers;

-- 12 TOP CUSTOMER CITIES 
-- We want to identify the cities containing the largest number of customers.
SELECT city,
COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC, city
LIMIT 10;

-- SECTION 7 (INTEGRATED CUSTOMER ANALYSIS)
-- 30 CUSTOMER FINANCIAL PROFILE ANALYSIS
WITH account_summary AS (
SELECT customer_id,
COUNT(account_id) AS total_accounts,
ROUND(SUM(balance_usd),2) AS total_account_balance_usd
FROM accounts
GROUP BY customer_id
),

transaction_summary AS (
SELECT a.customer_id,
COUNT(t.transaction_id) AS total_transactions,
ROUND(SUM(t.amount_usd),2) AS total_transaction_value_usd,
ROUND(AVG(t.amount_usd),2) AS average_transaction_amount_usd
FROM accounts a
JOIN transactions t
ON a.account_id = t.account_id
GROUP BY a.customer_id
),

loan_summary AS (
SELECT customer_id,
COUNT(loan_id) AS total_loans,
ROUND(SUM(loan_amount),2) AS total_loan_exposure_usd,
ROUND(AVG(interest_rate),2) AS average_interest_rate
FROM loans
GROUP BY customer_id
)

SELECT
c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
c.credit_score,
a.total_accounts,
a.total_account_balance_usd,
t.total_transactions,
t.total_transaction_value_usd,
l.total_loans,
l.total_loan_exposure_usd,
l.average_interest_rate
FROM customers c
LEFT JOIN account_summary a
ON c.customer_id = a.customer_id
LEFT JOIN transaction_summary t
ON c.customer_id = t.customer_id
LEFT JOIN loan_summary l
ON c.customer_id = l.customer_id
WHERE a.customer_id IS NOT NULL
AND t.customer_id IS NOT NULL
AND l.customer_id IS NOT NULL
ORDER BY l.total_loan_exposure_usd DESC
LIMIT 10;



