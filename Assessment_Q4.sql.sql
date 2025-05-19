

-- Assessment_Q4.sql

-- ========================================================
-- QUESTION 4: Customer Lifetime Value (CLV) Estimation
-- Goal: Estimate CLV per customer using tenure and transaction volume
-- CLV Formula:
-- (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
-- Assume: profit_per_transaction = 0.001 * transaction_value
-- ========================================================

WITH customer_transactions AS (
    -- Step 1: Aggregate total transaction value and count for each customer
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.amount) AS total_transaction_value
    FROM 
        savings_savingsaccount s
    GROUP BY 
        s.owner_id
),

customer_tenure AS (
    -- Step 2: Calculate account tenure in months (from date_joined to today)
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE) AS tenure_months
    FROM 
        users_customuser
)

-- Final CLV calculation
SELECT 
    t.owner_id AS customer_id,
    ct.name,
    ct.tenure_months,
    t.total_transactions,
    
    -- Estimated CLV formula using 0.1% profit per transaction
    ROUND(
        (t.total_transactions / NULLIF(ct.tenure_months, 0)) * 12 * (0.001 * t.total_transaction_value),
        2
    ) AS estimated_clv
FROM 
    customer_transactions t
JOIN 
    customer_tenure ct ON t.owner_id = ct.customer_id
ORDER BY 
    estimated_clv DESC;

