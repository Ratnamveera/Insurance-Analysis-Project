use branch_database;
Select *from brokerage;
Select *from fees;
Select *from individual_budget;
Select *from Invoice;
Select *from meeting;
Select *from opportunity;

#KPI 1. No of Invoice by Account Exec
SELECT Account_Executive, COUNT(invoice_number) AS Invoice_Count FROM Invoice GROUP BY Account_Executive;

#KPI 2. Yearly Meeting Count
SELECT YEAR(STR_TO_DATE(Meeting_date, '%Y-%m-%d')) AS year, COUNT(*) AS Meeting_count FROM meeting
WHERE Meeting_date IS NOT NULL 
GROUP BY YEAR(STR_TO_DATE(Meeting_date, '%Y-%m-%d'))
ORDER BY year;

#KPI 3: Cross Sell - Target, Achieve, New
#New - Target, Achieve, New
#Renewal - Target, Achieve, New
SELECT ib.Account_Executive, ib.Cross_sell_budget AS Cross_Sell_Target,
    COALESCE(SUM(CASE WHEN i.Income_Class = 'Cross Sell' THEN i.Amount END), 0) AS Cross_Sell_New,
    COALESCE(SUM(CASE WHEN b.Income_Class = 'Cross Sell' THEN b.Amount END), 0) AS Cross_Sell_Achieve,
    ib.New_Budget AS New_Target,
    COALESCE(SUM(CASE WHEN i.Income_Class = 'New' THEN i.Amount END), 0) AS New_New,
    COALESCE(SUM(CASE WHEN b.Income_Class = 'New' THEN b.Amount END), 0) AS New_Achieve,
    ib.Renewal_Budget AS Renewal_Target,
    COALESCE(SUM(CASE WHEN i.Income_Class = 'Renewal' THEN i.Amount END), 0) AS Renewal_New,
    COALESCE(SUM(CASE WHEN b.Income_Class = 'Renewal' THEN b.Amount END), 0) AS Renewal_Achieve
FROM Individual_Budget ib
LEFT JOIN Invoice i ON ib.Account_Executive = i.Account_Executive
LEFT JOIN brokerage b ON ib.Account_Executive = b.Account_Executive
GROUP BY ib.Account_Executive, ib.Cross_sell_budget, ib.New_Budget, ib.Renewal_Budget ORDER BY ib.Account_Executive;

#KPI 4. Stage Funnel by Revenue
SELECT Stage, SUM(Revenue_amount) AS Total_Revenue
FROM Opportunity
GROUP BY Stage
ORDER BY Total_Revenue DESC;

#KPI 5. No of meetings by Account Executive
SELECT Account_Executive, COUNT(*) AS Meeting_Count
FROM Meeting
GROUP BY Account_Executive;

#KPI 6. Top Open Opportunities
SELECT Opportunity_name, Revenue_amount
FROM Opportunity
WHERE Stage NOT IN ('Closed Won', 'Closed Lost')
ORDER BY Revenue_amount DESC
LIMIT 10;

