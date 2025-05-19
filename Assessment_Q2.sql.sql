-- Assessment_Q2.sql

-- ===========================================
-- QUESTION 2: Transaction Frequency Analysis
-- Goal: Segment users based on their average number of savings transactions per month.
-- ===========================================

WITH user_monthly_activity AS (
    -- Step 1: Count total transactions and calculate active months per user
    SELECT 
        sa.owner_id,
        
        -- Total transactions for each user
        COUNT(*) AS total_transactions,

        -- Count of DISTINCT year-month combinations = active months
        COUNT(DISTINCT DATE_FORMAT(sa.created_on, '%Y-%m')) AS active_months
    FROM 
        savings_savingsaccount sa
    GROUP BY 
        sa.owner_id
),

user_frequency AS (
    -- Step 2: Compute average transactions per month per user
    SELECT 
        uma.owner_id,
        total_transactions,
        active_months,
        
        -- Avoid division by zero; ensure at least 1 month
        ROUND(total_transactions / NULLIF(active_months, 0), 1) AS avg_txn_per_month,

        -- Step 3: Categorize based on average transactions/month
        CASE 
            WHEN total_transactions / NULLIF(active_months, 0) >= 10 THEN 'High Frequency'
            WHEN total_transactions / NULLIF(active_months, 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        user_monthly_activity uma
)

-- Step 4: Aggregate by frequency category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM 
    user_frequency
GROUP BY 
    frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency'); -- Ensures desired order



