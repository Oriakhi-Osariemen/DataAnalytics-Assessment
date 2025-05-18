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




## Assessment_Q2.sql – Transaction Frequency Analysis

### Objective: 

Categorize customers into frequency groups based on average monthly transactions.

### Approach:

Extracted YYYY-MM from transaction dates using DATE_FORMAT() in order to group by month.

Calculated number of monthly transactions per user.

Calculated average number of monthly transactions per user.

Used a CASE statement to group users into High, Medium, or Low Frequency.

Grouped and counted users by category with average transactions per category.



## Assessment_Q3.sql – Account Inactivity Alert

### Objective: I

dentify active accounts with no inflow transactions in the last 365 day

### Approach:

Filtered accounts with confirmed_amount > 0 to get the latest inflow date per plan. 

Joined with plans_plan to determine account type: Investment or Savings.

Used DATEDIFF() to calculate inactivity days.

Filtered accounts with inactivity_days > 365 and sorted by inactivity period.



## Assessment_Q4.sql – Customer Lifetime Value (CLV) Estimation

### Objective: Estimate CLV using the formula:

CLV = (Total Transactions / Tenure in Months) × 12 × Average Profit per Transaction

### Approach:

Calculated amount of tenure_months as first transaction date minus current date.

Added total value and quantity of transactions amount per user.

Converted transaction value into naira amount from kobo amount.

Computed estimated profit per transaction amount by 0.1% amount of average transaction amount.

Used the formula to calculate estimated CLV and sorted in descending order.




# Challenges & Solutions

## 1. Missing or Inaccurate Column Names
Problem: Some fields were not present in the schema.

Solution: Ran SHOW COLUMNS FROM on every table to double-check actual column names (e.g., instead of created, used created_at).

## 2. Unit Conversion (Kobo to Naira)
Problem: All money fields were in Kobo.

Solution: Divided money fields by 100 where it was possible to convert to Naira.

## 3. Avoiding Division by Zero
Problem: Tenure in months could be zero if all the transactions occurred during the same month.

Solution: Used NULLIF() to prevent division by zero while calculating CLV.

## 4. Ordering of Frequency Category in MySQL
Problem: MySQL does not sort CASE-based categories automatically.

Solution: Used FIELD() in the ORDER BY clause to force manually the desired order: High > Medium > Low.


