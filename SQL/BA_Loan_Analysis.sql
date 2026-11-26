-- Loan Analysis 
-- Total Loans
SELECT 
COUNT(*) AS total_loans
FROM loans;

-- Duplicate Loan IDs
SELECT loan_id,
COUNT(*) AS duplicate_count
FROM loans 
GROUP BY loan_id
HAVING COUNT(*)>1;

--Loan Amount Analysis
SELECT 
ROUND(SUM(loan_amount),2) AS total_loan_amount,
ROUND(AVG(loan_amount),2) AS average_loan_amount,
ROUND(MIN(loan_amount),2) AS minimum_loan_amount,
ROUND(MAX(loan_amount),2) AS maximum_loan_amount
FROM loans;

-- Interest Rate Analysis
SELECT 
ROUND(AVG(interest_rate),2) AS average_interest_rate,
ROUND(MIN(interest_rate),2) AS minimum_interest_rate,
ROUND(MAX(interest_rate),2) AS maximum_interest_rate
FROM loans;

-- Loan Trend by year
SELECT 
EXTRACT(YEAR FROM start_date) AS loan_year,
COUNT(*) AS loan_count,
ROUND(SUM(loan_amount),2) AS total_loan_amount,
ROUND(AVG(loan_amount),2) AS average_loan_amount
FROM loans
GROUP BY EXTRACT(YEAR FROM start_date)
ORDER BY loan_year;

-- Customer with loans
SELECT 
COUNT(DISTINCT customer_id) AS customers_with_loans
FROM loans;

-- Top 10 Customers by total laon amount
SELECT customer_id,
COUNT(*) AS loan_count,
ROUND(SUM(loan_amount),2) AS total_loan_amount
FROM loans
GROUP BY customer_id
ORDER BY total_loan_amount DESC
LIMIT 10;

-- Loan Distribution by Interest Rate
SELECT interest_rate,
COUNT(*) AS loan_count
FROM loans
GROUP BY interest_rate
ORDER BY interest_rate;