# Data Analytics Assessment

This repository contains my SQL solutions to a Data Analytics assessment that evaluates business logic, transaction behavior, and SQL proficiency using MySQL. Each `.sql` file corresponds to a question and contains a single, well-commented query that solves the respective problem.

---

## Author

**Pamella Ishiwu**  
Email: pamellaishiwu@gmail.com  
Date: May 19, 2025

---

## Questions & Approach

### ✅ Q1: High-Value Customers with Multiple Products

**Goal**: Identify customers who have both a funded savings plan and a funded investment plan.

**Approach**:  
I filtered savings plans where `is_regular_savings = 1` and investment plans where `is_a_fund = 1`. Then, I aggregated the data to count the number of savings and investment plans per customer. I also summed up their total confirmed deposits (converted from kobo to naira), which were grouped by customer.  
Finally, I joined these results with the `users_customuser` table and combined the `first_name` and `last_name` columns to produce the full name, just like the expected output format (e.g., "John Doe"). I sorted the results by total deposits in descending order.

---

### ✅ Q2: Transaction Frequency Analysis

**Goal**: Categorize customers based on how frequently they perform transactions per month.

**Approach**:  
I counted all savings transactions for each customer and calculated the number of full months since their first transaction. I then computed the average number of transactions per month by dividing total transactions by the months of activity.  
Based on the average frequency, I used `CASE` statements to group each customer into:  
- "High Frequency" (≥10/month)  
- "Medium Frequency" (3–9/month)  
- "Low Frequency" (≤2/month)  
Finally, I grouped the data by frequency category and calculated the total number of customers and average transactions per month for each group.

---

### ✅ Q3: Account Inactivity Alert

**Goal**: Find active savings or investment accounts with no inflow in the past 365 days.

**Approach**:  
I calculated the most recent transaction date (`created_on`) for each savings account and investment plan. I filtered investment plans by `status_id = 1` to include only active plans.  
Then, I combined both savings and investment data using `UNION ALL`. I used `DATEDIFF(CURDATE(), last_transaction_date)` to calculate the number of days since the last transaction.  
Finally, I filtered for accounts where the inactivity period exceeded 365 days and sorted the results by inactivity in descending order.

---

### ✅ Q4: Customer Lifetime Value (CLV) Estimation

**Goal**: Estimate CLV using total transactions and account tenure (in months).

**Approach**:  
I calculated the number of full months since each customer’s signup date using `TIMESTAMPDIFF(MONTH, date_joined, CURDATE())`. I also counted their total number of savings transactions.  
To estimate CLV, I assumed that profit per transaction is 0.1% of each transaction amount (which is in kobo, so I divided by 1000 to get naira profit).  
I applied the simplified CLV formula:  
> `CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction`  
Finally, I joined the result with user data, created full names, and ordered the customers by CLV in descending order.

---

## Challenges & Resolutions

1. **Missing full name field**:  
   The `users_customuser` table didn’t have a single `name` column. I resolved this by concatenating `first_name` and `last_name` into a new alias column, `name`, to match the format used in the expected output.

2. **Handling dates in MySQL**:  
   I initially used `GETDATE()` as I was familiar with SQL Server, but MySQL uses `CURDATE()` instead. I updated all date-related functions accordingly, including `DATEDIFF()` and `TIMESTAMPDIFF()`.

3. **Irregular date ranges in frequency analysis**:  
   In Question 2, calculating transaction frequency per month wasn’t straightforward because customers had different durations of activity. To handle this, I used `TIMESTAMPDIFF(MONTH, MIN(created_on), MAX(created_on))` to estimate the active months. I also ensured that the result was never divided by zero by enforcing a minimum of 1 month. This ensured customers were segmented fairly into High, Medium, or Low frequency groups.

4. **All values in kobo**:  
   Since transaction amounts are stored in kobo, I had to divide them by 100 to convert to naira, and by 1000 when calculating profit percentages to avoid overestimation.

---


