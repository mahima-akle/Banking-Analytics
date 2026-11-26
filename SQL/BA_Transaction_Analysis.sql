-- 01.Data Validation(SQL Analysis)
--Total Transactions
SELECT COUNT(*) AS total_transactions 
FROM transactions;


-- Sample transactions
SELECT *
FROM transactions
LIMIT 10;


-- Transactions without matching account
SELECT COUNT(*) AS unmatched_transactions
FROM transactions t
LEFT JOIN accounts a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;


-- Transactions without matching merchant
SELECT COUNT(*) AS unmatched_transactions
FROM transactions t
LEFT JOIN merchants m
    ON t.merchant_id = m.merchant_id
WHERE m.merchant_id IS NULL;



-- 02. TRANSACTION DATE RANGE

SELECT
    MIN(transaction_date) AS first_transaction,
    MAX(transaction_date) AS last_transaction
FROM transactions;



-- 03. OVERALL TRANSACTION KPIs

SELECT
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount_usd), 2) AS total_transaction_amount,
    ROUND(AVG(amount_usd), 2) AS average_transaction_amount,
    ROUND(MIN(amount_usd), 2) AS minimum_transaction,
    ROUND(MAX(amount_usd), 2) AS maximum_transaction
FROM transactions;



-- 04. YEAR-WISE TRANSACTION ANALYSIS


SELECT
    EXTRACT(YEAR FROM transaction_date) AS transaction_year,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount_usd), 2) AS total_amount,
    ROUND(AVG(amount_usd), 2) AS average_amount
FROM transactions
GROUP BY transaction_year
ORDER BY transaction_year;



-- 05. MONTH-WISE TRANSACTION ANALYSIS

SELECT
    EXTRACT(YEAR FROM transaction_date) AS transaction_year,
    EXTRACT(MONTH FROM transaction_date) AS transaction_month,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount_usd), 2) AS total_amount
FROM transactions
GROUP BY
    EXTRACT(YEAR FROM transaction_date),
    EXTRACT(MONTH FROM transaction_date)
ORDER BY
    transaction_year,
    transaction_month;