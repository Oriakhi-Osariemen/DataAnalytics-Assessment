WITH transaction_stats AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        MIN(s.created_on) AS first_transaction_date,  
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) / 100 AS total_transaction_value_naira  -- convert kobo to naira
    FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id
    WHERE s.confirmed_amount > 0
    GROUP BY u.id
),

clv_calculation AS (
    SELECT
        customer_id,
        name,
        TIMESTAMPDIFF(MONTH, first_transaction_date, CURDATE()) AS tenure_months,
        total_transactions,
        ROUND((total_transaction_value_naira / total_transactions) * 0.001, 4) AS avg_profit_per_transaction,
        ROUND(((total_transactions / NULLIF(TIMESTAMPDIFF(MONTH, first_transaction_date, CURDATE()), 0)) * 12 *
               ((total_transaction_value_naira / total_transactions) * 0.001)), 2) AS estimated_clv
    FROM transaction_stats
)

SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM clv_calculation
ORDER BY estimated_clv DESC;
