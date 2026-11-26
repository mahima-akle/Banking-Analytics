-- ##ACCOUNT ANALYSIS##
-- 1 Total accounts
SELECT COUNT(*) AS total_accounts
FROM accounts;

-- 2 Account Type Distribution
SELECT account_type,
COUNT(*) AS account_count,
ROUND(SUM(balance_usd),2) AS total_balace,
ROUND(AVG(balance_usd),2) AS average_balance
FROM accounts
GROUP BY account_type
ORDER BY account_count DESC;

-- 3 Account balance analysis(overall account balance analysis)
SELECT 
ROUND(SUM(balance_usd),2) AS total_account_balance,
ROUND(AVG(balance_usd),2) AS average_account_balance,
ROUND(MIN(balance_usd),2) AS minimum_balance,
ROUND(MAX(balance_usd),2) AS maximum_balance
FROM accounts;

-- 4 Accounts opening trend by year
SELECT 
EXTRACT(YEAR FROM open_date) AS opening_year,
COUNT(*) AS accounts_opened
FROM accounts
GROUP BY EXTRACT(YEAR FROM open_date)
ORDER BY opening_year;

-- 5 Average transaction per account 
-- :: Convert value to another data type
SELECT 
ROUND(COUNT(*)::NUMERIC/
(SELECT COUNT(*)
FROM accounts),2) AS average_transactions_per_account
FROM transactions;

-- 6 Accounts Transaction Coverage
SELECT
COUNT(DISTINCT a.account_id) AS total_accounts,
COUNT(DISTINCT t.account_id) AS accounts_with_transactions,
COUNT(DISTINCT a.account_id)-
COUNT(DISTINCT t.account_id) AS accounts_without_transactions
FROM accounts a
LEFT JOIN transactions t
ON a.account_id = t.account_id;

-- 7 Top 10 Accounts by Transaction Count
SELECT a.account_id, a.account_type,
COUNT(t.transaction_id) AS transaction_count
FROM accounts a
LEFT JOIN transactions t
ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_type
ORDER BY transaction_count DESC
LIMIT 10;


-- 8 Account balance by account type
SELECT account_type,
ROUND(SUM(balance_usd),2) AS total_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;