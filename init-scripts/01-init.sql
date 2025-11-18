DROP TABLE IF EXISTS transactions CASCADE;
CREATE TABLE transactions (
    account VARCHAR(32) NOT NULL,
    date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    category VARCHAR(50)
);
CREATE INDEX idx_transactions_date ON transactions(date);
CREATE INDEX idx_transactions_category ON transactions(category);
CREATE INDEX idx_transactions_location ON transactions(location);
DO $$ BEGIN RAISE NOTICE 'Database creation successfully!';
END $$;