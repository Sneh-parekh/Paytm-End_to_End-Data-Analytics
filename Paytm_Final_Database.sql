CREATE DATABASE paytm_final_db;
USE paytm_final_db;
SHOW tables;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----1. ALL_USERS — Business Queries-----
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---1. Total number of users---
SELECT COUNT(*) AS total_users
FROM all_users;

---2. Users joined per year---
SELECT YEAR(Join_Date) AS join_year, COUNT(*) AS users_count
FROM all_users
GROUP BY join_year
ORDER BY join_year;

---3. Users joined per month (all years)---
SELECT MONTHNAME(Join_Date) AS month, COUNT(*) AS users_count
FROM all_users
GROUP BY month
ORDER BY users_count DESC;

---4. Average user age---
SELECT ROUND(AVG(Age), 1) AS avg_age
FROM all_users;

---5. Age distribution buckets---
SELECT
CASE
  WHEN Age < 25 THEN 'Under 25'
  WHEN Age BETWEEN 25 AND 35 THEN '25–35'
  WHEN Age BETWEEN 36 AND 50 THEN '36–50'
  ELSE '50+'
END AS age_group,
COUNT(*) AS users
FROM all_users
GROUP BY age_group;

---6. New users trend month-wise (year & month)---
SELECT
YEAR(Join_Date) AS year,
MONTHNAME(Join_Date) AS month,
COUNT(*) AS users
FROM all_users
GROUP BY year, month;

---7. Youngest and oldest users---
SELECT MIN(Age) AS youngest, MAX(Age) AS oldest
FROM all_users;

---8. Users joined in last 6 months---
SELECT COUNT(*) AS recent_users
FROM all_users
WHERE Join_Date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

---9. Users count per year ordered by growth---
SELECT YEAR(Join_Date) AS year, COUNT(*) AS users
FROM all_users
GROUP BY year
ORDER BY users DESC;

---10. User cohort by join year---
SELECT YEAR(Join_Date) AS cohort_year, COUNT(*) AS users
FROM all_users
GROUP BY cohort_year;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----2. LOANS — Business Queries-----
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---1. Total loan amount disbursed---
SELECT ROUND(SUM(Loan_Amount)/1000000, 2) AS total_loan_million
FROM loans;

---2. Loan amount by loan type---
SELECT Loan_Type, ROUND(SUM(Loan_Amount)/1000000,2) AS total_amount_mn
FROM loans
GROUP BY Loan_Type;

---3. Number of loans per loan type---
SELECT Loan_Type, COUNT(*) AS loan_count
FROM loans
GROUP BY Loan_Type;

---4. Average loan amount per type---
SELECT Loan_Type, ROUND(AVG(Loan_Amount),0) AS avg_loan
FROM loans
GROUP BY Loan_Type;

---5. Payment status distribution---
SELECT Payment_Status, COUNT(*) AS count
FROM loans
GROUP BY Payment_Status;

---6. Loan failure reasons---
SELECT Reason, COUNT(*) AS failed_count
FROM loans
WHERE Payment_Status != 'Success'
GROUP BY Reason;

---7. Failure % by reason---
SELECT Reason,
ROUND(COUNT(*) * 100.0 /
(SELECT COUNT(*) FROM loans WHERE Payment_Status != 'Success'), 2) AS failure_pct
FROM loans
WHERE Payment_Status != 'Success'
GROUP BY Reason;

---8. Loan failures by loan type---
SELECT Loan_Type, COUNT(*) AS failed_loans
FROM loans
WHERE Payment_Status != 'Success'
GROUP BY Loan_Type;

---9. Monthly loan amount trend---
SELECT YEAR(Date) AS year, MONTH(Date) AS month, SUM(Loan_Amount) AS total_amount
FROM loans
GROUP BY year, month;

---10. Payment mode usage---
SELECT Payment_Mode, COUNT(*) AS usage_count
FROM loans
GROUP BY Payment_Mode;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----3. INSURANCE — Business Queries-----
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---1. Total premium collected---
SELECT ROUND(SUM(Premium)/1000000,2) AS total_premium_mn
FROM insurance;

---2. Premium by insurance type---
SELECT Insurance_Type, ROUND(SUM(Premium)/1000000,2) AS premium_mn
FROM insurance
GROUP BY Insurance_Type;

---3. Policies sold per insurance type---
SELECT Insurance_Type, COUNT(*) AS policy_count
FROM insurance
GROUP BY Insurance_Type;

---4. Failed insurance payments---
SELECT COUNT(*) AS failed_transactions
FROM insurance
WHERE Payment_Status != 'Success';

---5. Failure reasons distribution---
SELECT Reason, COUNT(*) AS failed_count
FROM insurance
WHERE Payment_Status != 'Success'
GROUP BY Reason;

---6. Failure reason by insurance type---
SELECT Insurance_Type, Reason, COUNT(*) AS count
FROM insurance
WHERE Payment_Status != 'Success'
GROUP BY Insurance_Type, Reason;

---7. Monthly premium trend---
SELECT YEAR(Date) AS year, MONTH(Date) AS month, SUM(Premium) AS total_premium
FROM insurance
GROUP BY year, month;

---8. Success rate of insurance payments---
SELECT
ROUND(
SUM(CASE WHEN Payment_Status='Success' THEN 1 ELSE 0 END)*100.0/COUNT(*),2
) AS success_rate
FROM insurance;

---9. Top revenue insurance product---
SELECT Insurance_Type, SUM(Premium) AS total
FROM insurance
GROUP BY Insurance_Type
ORDER BY total DESC
LIMIT 1;

---10. Average premium per policy---
SELECT ROUND(AVG(Premium),2) AS avg_premium
FROM insurance;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----4. MONEY_TRANSFER — Business Queries-----
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---1. Total transfer amount---
SELECT ROUND(SUM(Amount)/1000000,2) AS total_transfer_mn
FROM money_transfer;

---2. Transfer amount by transfer type---
SELECT Transfer_Type, ROUND(SUM(Amount)/1000000,2) AS amount_mn
FROM money_transfer
GROUP BY Transfer_Type;

---3. Transaction success rate---
SELECT
ROUND(
SUM(CASE WHEN Payment_Status='Success' THEN 1 ELSE 0 END)*100.0/COUNT(*),2
) AS success_rate
FROM money_transfer;

---4. Failed transactions reasons---
SELECT Reason, COUNT(*) AS failed_count
FROM money_transfer
WHERE Payment_Status != 'Success'
GROUP BY Reason;

---5. Transfers by state---
SELECT State, COUNT(*) AS transactions
FROM money_transfer
GROUP BY State
ORDER BY transactions DESC;

---6. Monthly transfer trend---
SELECT YEAR(Date) AS year, MONTH(Date) AS month, SUM(Amount) AS total_amount
FROM money_transfer
GROUP BY year, month;

---7. Average transaction amount---
SELECT ROUND(AVG(Amount),2) AS avg_amount
FROM money_transfer;

---8. Transfer type preference---
SELECT Transfer_Type, COUNT(*) AS usage
FROM money_transfer
GROUP BY Transfer_Type;

---9. High-value transfers (>50k)---
SELECT COUNT(*) AS high_value_txn
FROM money_transfer
WHERE Amount > 50000;

---10. Failure % by reason---
SELECT Reason,
ROUND(COUNT(*)*100.0/
(SELECT COUNT(*) FROM money_transfer WHERE Payment_Status!='Success'),2) AS pct
FROM money_transfer
WHERE Payment_Status!='Success'
GROUP BY Reason;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----5. RECHARGE_BILLS — Business Queries-----
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---1. Total recharge amount---
SELECT ROUND(SUM(Amount)/1000000,2) AS total_recharge_mn
FROM recharge_bills;

---2. Recharge type distribution---
SELECT Recharge_Type, COUNT(*) AS count
FROM recharge_bills
GROUP BY Recharge_Type;

---3. Failed recharges---
SELECT COUNT(*) AS failed_recharges
FROM recharge_bills
WHERE Payment_Status != 'Success';

---4. Failure reasons---
SELECT Reason, COUNT(*) AS count
FROM recharge_bills
WHERE Payment_Status != 'Success'
GROUP BY Reason;

---5. Monthly recharge trend---
SELECT YEAR(Date) AS year, MONTH(Date) AS month, SUM(Amount) AS total
FROM recharge_bills
GROUP BY year, month;

---6. Success rate---
SELECT
ROUND(
SUM(CASE WHEN Payment_Status='Success' THEN 1 ELSE 0 END)*100.0/COUNT(*),2
) AS success_rate
FROM recharge_bills;

---7. Average recharge value---
SELECT ROUND(AVG(Amount),2) AS avg_recharge
FROM recharge_bills;

---8. Recharge by state---
SELECT State, COUNT(*) AS count
FROM recharge_bills
GROUP BY State;

---9. High-frequency recharge users---
SELECT User_ID, COUNT(*) AS txn_count
FROM recharge_bills
GROUP BY User_ID
HAVING txn_count > 5;

---10. Most used recharge category---
SELECT Recharge_Type, COUNT(*) AS total
FROM recharge_bills
GROUP BY Recharge_Type
ORDER BY total DESC
LIMIT 1;
