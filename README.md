# DataAnalytics-Assessment
SQL assessment for data analytics test.

# Per-Question Explanations

## Assessment_Q1.sql – High-Value Customers with Multiple Products

### Objective: 

Identify customers with at least one funded savings plan and one funded investment plan, sorted by total deposits.

### Approach:

Filtered savings_savings account for funded savings plans (is_regular_savings = 1 and confirmed_amount > 0).

Filtered investment plans using is_a_fund = 1 with confirmed_amount > 0.

Used subqueries to count savings and investment plans per user.

Joined these counts with the users_customuser table to get names.

Total deposits (in naira, converted from kobo) and sorted by total deposits.
