use policy_data;
Select *from additional_fields;
Select *from claims;
Select *from customer_information;
Select *from payment_history;
Select *from policy_details;

# KPI 1: Total Policy
SELECT COUNT(*) AS "Total Policies" FROM Policy_Details;

#KPI 2: Total Customers
SELECT COUNT(DISTINCT Customer_ID) AS "Total Customers" FROM customer_information;

#KPI 3: Age Bucket Wise Policy Count
SELECT Age_Bucket, COUNT(*) AS "Policy Count" FROM Customer_Information c JOIN Policy_Details p ON c.Customer_ID = p.Customer_ID 
GROUP BY Age_Bucket;

SELECT Age_Bucket, COUNT(*) AS "Policy Count" 
FROM (SELECT Customer_ID, CASE WHEN Age BETWEEN 18 AND 25 THEN '18-25' WHEN Age BETWEEN 26 AND 35 THEN '26-35' 
WHEN Age BETWEEN 36 AND 45 THEN '36-45' WHEN Age BETWEEN 46 AND 60 THEN '46-60' ELSE '60+' END AS Age_Bucket FROM Customer_Information) c
JOIN Policy_Details p ON c.Customer_ID = p.Customer_ID GROUP BY Age_Bucket;

#KPI 4: Gender Wise Policy Count
SELECT Gender, COUNT(*) AS "Policy Count" FROM Customer_Information c JOIN Policy_Details p ON c.Customer_ID = p.Customer_ID GROUP BY Gender;

#KPI 5: Policy Type Wise Policy Count
SELECT Policy_Type, COUNT(*) AS "Policy Count" FROM Policy_Details GROUP BY Policy_Type;

#KPI 6: Policy Expire This Year
SELECT COUNT(*) AS "Policies Expiring This Year" FROM Policy_Details WHERE Policy_Expiring_Year = YEAR(CURDATE());

#KPI 7: Premium Growth Rate
WITH YearlyPremium AS (SELECT YEAR(STR_TO_DATE(Policy_End_Date, '%Y-%m-%d')) AS Year, CAST(SUM(Premium_Amount) AS DECIMAL(10,2)) AS Total_Premium 
FROM Policy_Details WHERE Policy_End_Date IS NOT NULL GROUP BY YEAR(STR_TO_DATE(Policy_End_Date, '%Y-%m-%d'))) 
SELECT y.Year, y.Total_Premium, COALESCE(LAG(y.Total_Premium) OVER (ORDER BY y.Year), 0) AS Previous_Year_Premium, 
CONCAT(ROUND(CASE WHEN LAG(y.Total_Premium) OVER (ORDER BY y.Year) IS NULL THEN 0 
ELSE ((y.Total_Premium - LAG(y.Total_Premium) OVER (ORDER BY y.Year)) / LAG(y.Total_Premium) OVER (ORDER BY y.Year)) * 100 END, 2), '%') 
AS Premium_Growth_Rate_Percentage FROM YearlyPremium y ORDER BY y.Year;

#KPI 8: Claim Status Wise Policy Count
SELECT Claim_Status, COUNT(DISTINCT Policy_ID) AS "Policy Count" FROM Claims GROUP BY Claim_Status;

#KPI 9: Payment Status Wise Policy Count
SELECT Payment_Status, COUNT(Policy_ID) AS "Policy Count" FROM Payment_History GROUP BY Payment_Status;

#KPI 10: Total Claim Amount
SELECT SUM(Claim_Amount) AS "Total Claim Amount" FROM Claims;