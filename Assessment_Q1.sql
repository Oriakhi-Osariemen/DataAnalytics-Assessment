
-- Identify users with at least one funded savings plan and one funded investment plan

SELECT 
    u.id AS owner_id,
    concat(u.first_name, ' ', u.last_name) AS name

    -- Count number of funded savings plans per user
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 THEN s.id 
    END) AS savings_count,

    -- Count number of funded investment plans per user
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 THEN s.id 
    END) AS investment_count,

    -- Sum of confirmed inflows from both savings and investment plans, converted from kobo to naira
    ROUND(SUM(CASE 
        WHEN p.is_regular_savings = 1 OR p.is_a_fund = 1 THEN s.confirmed_amount 
        ELSE 0 
    END) / 100.0, 2) AS total_deposits

FROM 
    users_customuser u

-- Join savings accounts to users
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id

-- Join plans to savings accounts to determine type of plan
JOIN 
    plans_plan p ON s.plan_id = p.id

-- Only include funded plans (inflows > 0)
WHERE 
    s.confirmed_amount > 0

-- Group by user to aggregate counts and deposits
GROUP BY 
    u.id, u.name

-- Ensure users have at least one savings AND one investment plan
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.id END) > 0
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.id END) > 0

-- Rank users by highest total deposit
ORDER BY 
    total_deposits DESC;
