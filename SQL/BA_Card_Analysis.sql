-- Card Analysis
SELECT 
COUNT(*) AS total_cards
FROM cards;

-- Duplicate card IDs
SELECT card_id,
COUNT(*) AS duplicate_count
FROM cards
GROUP BY card_id
HAVING COUNT(*)>1;

-- Card type distribution
SELECT card_type,
COUNT(*) AS card_count
FROM cards
GROUP BY card_type
ORDER BY card_count DESC;

-- Card per account
SELECT account_id,
COUNT(*) AS card_count
FROM cards
GROUP BY account_id
ORDER BY card_count DESC
LIMIT 10;

-- Card Expiration Year
SELECT 
EXTRACT(YEAR FROM expiration_date) AS expiration_year,
COUNT(*) AS card_count
FROM cards
GROUP BY expiration_year
ORDER BY expiration_year;

-- Accounts with cards
SELECT 
COUNT(DISTINCT account_id) AS acount_with_cards
FROM cards;