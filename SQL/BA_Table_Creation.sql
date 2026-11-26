CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    credit_score INT,
    created_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS accounts (
    account_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    account_type VARCHAR(20),
    balance_usd NUMERIC(12,2),
    open_date DATE,
    CONSTRAINT fk_accounts_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS cards (
    card_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20),
    card_type VARCHAR(20),
    expiration_date DATE,
    CONSTRAINT fk_cards_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

CREATE TABLE IF NOT EXISTS merchants (
    merchant_id VARCHAR(20) PRIMARY KEY,
    merchant_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS branches (
    branch_id VARCHAR(20) PRIMARY KEY,
    branch_name VARCHAR(100),
    manager_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS loans (
    loan_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    loan_amount NUMERIC(12,2),
    interest_rate NUMERIC(5,2),
    start_date DATE,
    CONSTRAINT fk_loans_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id VARCHAR(25) PRIMARY KEY,
    account_id VARCHAR(20),
    merchant_id VARCHAR(20),
    amount_usd NUMERIC(12,2),
    transaction_date TIMESTAMP,
    CONSTRAINT fk_transactions_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id),
    CONSTRAINT fk_transactions_merchant
        FOREIGN KEY (merchant_id)
        REFERENCES merchants(merchant_id)
);