-- HR Analytics SQL Analysis
-- Dataset: IBM HR Analytics Employee Attrition

select count(*) from hr_analytics.hr_employee;

-- overall attrition rate
select 
count(*) as total_emp,
sum(case when Attrition='Yes' then 1 else 0 end ) as attrition_count,
round(sum(case when Attrition='Yes' then 1 else 0 end) * 100.0/ count(*),2) as attrition_rate
from hr_employee;

-- department wise attrition
select 
department,
count(*) as total,
sum(case when Attrition='Yes' then 1 else 0 end ) as attrition,
round(sum(case when Attrition='Yes' then 1 else 0 end) * 100.0/ count(*),2) as attrition_rate
from hr_employee
group by department
order by attrition_rate desc;

-- age wise attrition
select
case
when age < 25 then 'under 25'
when age between 25 and 35 then '25-35'
when age between 36 and 45 then '36-45'
else 'above 45'
end as age_group,
count(*) as total,
sum(case when Attrition='Yes' then 1 else 0 end ) as attrition
from hr_employee
group by age_group
order by attrition desc;

-- salary wise attrition
select 
monthlyincome,attrition,department
from hr_employee
order by monthlyincome asc;

-- job satisfaction vs attrition
select jobsatisfaction,
count(*) as total,
sum(case when Attrition='Yes' then 1 else 0 end ) as attrition
from hr_employee
group by jobsatisfaction
order by jobsatisfaction;
