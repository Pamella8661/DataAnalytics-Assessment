-- Assessment_Q1.sql

-- ===========================================
-- QUESTION 1: High-Value Customers with Multiple Products
-- Goal: Identify users who have BOTH at least one funded savings plan
--       AND at least one funded investment plan, sorted by total deposits.
-- ===========================================

SELECT 
    u.id AS owner_id,

    -- Concatenating first name and last name to match expected format (e.g., "John Doe")
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Counting number of DISTINCT savings plans (assuming plan_type_id = 1 is savings)
    COUNT(DISTINCT CASE WHEN p.plan_type_id = 1 THEN p.id END) AS savings_count,

    -- Counting number of DISTINCT investment plans (assuming plan_type_id = 2 is investment)
    COUNT(DISTINCT CASE WHEN p.plan_type_id = 2 THEN p.id END) AS investment_count,

    -- Summing all deposit amounts tied to the user's plans
    SUM(s.amount) AS total_deposits

FROM 
    users_customuser u

-- Join plans to link each user to their plans
JOIN 
    plans_plan p ON u.id = p.owner_id

-- Join savings accounts to ensure we're only dealing with funded plans (plans with deposits)
JOIN 
    savings_savingsaccount s ON p.id = s.plan_id

GROUP BY 
    u.id, u.first_name, u.last_name

-- Only return users who have both savings AND investment plans
HAVING 
    savings_count >= 1 AND investment_count >= 1

-- Sort users from highest to lowest based on total deposits
ORDER BY 
    total_deposits DESC;