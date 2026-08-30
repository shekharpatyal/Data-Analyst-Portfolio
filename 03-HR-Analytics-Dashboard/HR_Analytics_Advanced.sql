
-- HR Analytics - Complete SQL Analysis

-- 1.1 Overall Employee Count
SELECT COUNT(*) AS total_employees FROM hr_employee;

-- 1.2 Overall Attrition Rate
SELECT 
    COUNT(*) AS total_emp,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_employee;

-- 1.3 Department Wise Attrition
SELECT 
    Department,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_employee
GROUP BY Department
ORDER BY attrition_rate DESC;

-- 1.4 Age Group Wise Attrition
SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        ELSE 'Above 45'
    END AS age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_employee
GROUP BY age_group
ORDER BY attrition DESC;

-- 1.5 Job Satisfaction vs Attrition
SELECT 
    JobSatisfaction,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_employee
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- 2.1 Attrition by Salary Bracket (CTE)
WITH SalaryBrackets AS (
    SELECT 
        EmployeeNumber, 
        Attrition, 
        MonthlyIncome,
        CASE 
            WHEN MonthlyIncome < 3000 THEN 'Low (<3k)'
            WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Mid (3k-6k)'
            WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'High (6k-10k)'
            ELSE 'Very High (>10k)'
        END AS SalaryBracket
    FROM hr_employee
)
SELECT 
    SalaryBracket,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate
FROM SalaryBrackets
GROUP BY SalaryBracket
ORDER BY AttritionRate DESC;

-- 2.2 Top 5 Job Roles with Highest Attrition (RANK)
WITH RoleAttrition AS (
    SELECT 
        JobRole,
        COUNT(*) AS TotalEmployees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
        ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate,
        RANK() OVER (ORDER BY SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) DESC) AS RankAttrition
    FROM hr_employee
    GROUP BY JobRole
)
SELECT 
    JobRole, 
    TotalEmployees, 
    AttritionCount, 
    AttritionRate
FROM RoleAttrition
WHERE RankAttrition <= 5;

-- 2.3 Attrition by Age and Gender
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        ELSE 'Above 45'
    END AS AgeGroup,
    SUM(CASE WHEN Gender = 'Male' AND Attrition = 'Yes' THEN 1 ELSE 0 END) AS MaleAttrition,
    SUM(CASE WHEN Gender = 'Female' AND Attrition = 'Yes' THEN 1 ELSE 0 END) AS FemaleAttrition,
    COUNT(*) AS TotalEmployees,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS OverallAttritionRate
FROM hr_employee
GROUP BY AgeGroup
ORDER BY OverallAttritionRate DESC;

-- 2.4 Work-Life Balance vs Attrition
SELECT 
    WorkLifeBalance,
    COUNT(*) AS Total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate
FROM hr_employee
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- 2.5 Average Years at Company for Churned vs Retained
SELECT 
    Attrition,
    ROUND(AVG(YearsAtCompany), 2) AS AvgYearsAtCompany,
    ROUND(AVG(YearsInCurrentRole), 2) AS AvgYearsInRole,
    ROUND(AVG(YearsSinceLastPromotion), 2) AS AvgYearsSincePromotion
FROM hr_employee
GROUP BY Attrition;
