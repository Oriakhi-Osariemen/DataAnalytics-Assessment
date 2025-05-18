WITH customer_tx AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        MIN(s.created_on) AS first_transaction_date,
        COUNT(*) AS total_transactions,
        ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_value_kobo
    FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id
    WHERE s.confirmed_amount > 0
    GROUP BY u.id, u.first_name, u.last_name
),

-- Calculate tenure in months and estimate CLV
clv_table AS (
    SELECT 
        customer_id,
        name,
        TIMESTAMPDIFF(MONTH, first_transaction_date, CURDATE()) AS tenure_months,
        total_transactions,
        ROUND(total_value_kobo / total_transactions, 2) * total_transactions AS estimated_clv
    FROM customer_tx
)

SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) AS estimated_clv
FROM clv_table
ORDER BY estimated_clv DESC;
