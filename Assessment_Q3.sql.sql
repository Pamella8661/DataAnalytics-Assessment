

-- Assessment_Q3.sql

-- ================================================
-- QUESTION 3: Account Inactivity Alert
-- Goal: Flag savings or investment accounts with no inflow in the past 365 days
-- ================================================

WITH savings_last_txn AS (
    -- Get the latest transaction date for each savings account
    SELECT 
        id AS plan_id,
        owner_id,
        MAX(created_on) AS last_transaction_date,
        'Savings' AS type
    FROM 
        savings_savingsaccount
    GROUP BY 
        id, owner_id
),

investment_last_txn AS (
    -- Get the latest transaction date for each active investment plan
    SELECT 
        id AS plan_id,
        owner_id,
        MAX(created_on) AS last_transaction_date,
        'Investment' AS type
    FROM 
        plans_plan
    WHERE 
        status_id = 1 -- assuming status_id = 1 means "active"
    GROUP BY 
        id, owner_id
),

combined_last_txn AS (
    -- Combine savings and investment last transactions into a single table
    SELECT * FROM savings_last_txn
    UNION ALL
    SELECT * FROM investment_last_txn
)

-- Final selection: only accounts with no activity in the last 365 days
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURRENT_DATE, last_transaction_date) AS inactivity_days
FROM 
    combined_last_txn
WHERE 
    DATEDIFF(CURRENT_DATE, last_transaction_date) > 365
ORDER BY 
    inactivity_days DESC;


