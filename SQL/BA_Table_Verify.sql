SELECT COUNT(*) AS customer_count FROM customers;
SELECT * FROM customers LIMIT 10;

SELECT COUNT(*) AS account_count FROM accounts;
SELECT * FROM accounts LIMIT 10;

SELECT COUNT(*) AS card_count FROM cards;
SELECT * FROM cards LIMIT 10;

SELECT COUNT(*) AS merchant_count FROM merchants;
SELECT * FROM merchants LIMIT 10;

SELECT COUNT(*) AS loan_count FROM loans;
SELECT * FROM loans LIMIT 10;

SELECT COUNT(*) AS branch_count FROM branches;
SELECT * FROM branches LIMIT 10;

SELECT COUNT(*) AS transaction_count FROM transactions;

SELECT current_user;
ALTER ROLE postgres WITH PASSWORD '20D07J'


