-- Replace s.created_at with s.created (or the correct column name)

WITH user_monthly_tx AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.created_on, '%Y-%m') AS month_year,
        COUNT(*) AS monthly_txn_count
    FROM savings_savingsaccount s
    GROUP BY s.owner_id, DATE_FORMAT(s.created_on, '%Y-%m')
),

user_avg_tx AS (
    SELECT
        owner_id,
        ROUND(AVG(monthly_txn_count), 2) AS avg_txn_per_month
    FROM user_monthly_tx
    GROUP BY owner_id
),

categorized_users AS (
    SELECT
        owner_id,
        avg_txn_per_month,
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM user_avg_tx
)

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
