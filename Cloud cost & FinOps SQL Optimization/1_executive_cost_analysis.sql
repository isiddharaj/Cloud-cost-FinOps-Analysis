use cloud_cost_finops;
select * from cloud_cost_finops_cleaned;
 
-- Page 1 — Executive Cost Overview

-- Q1. What is the total cloud cost?
select sum(actual_cost) as total_cloud_cost
from cloud_cost_finops_cleaned;

-- Q2. What is the total budget and budget variance?
select sum(budget) as total_cloud_budget,
       sum(actual_cost) as total_cloud_cost,
       sum(budget) - sum(actual_cost) as budget_variance
from cloud_cost_finops_cleaned;       

-- Q3. What is the monthly cloud spending trend?
select
      YEAR(date) as year,
      MONTH(date) as month,
      sum(actual_cost) as monthly_cost
from cloud_cost_finops_cleaned group by YEAR(date), MONTH(date);    

-- Q4. Which cloud provider has the highest spending?
select cloud_provider,
	  sum(actual_cost) as total_spending
from cloud_cost_finops_cleaned group by cloud_provider order by total_spending desc;

-- Q5. Which departments are exceeding their budget?  
select department,
      sum(actual_cost) as total_cost,
      sum(budget) as total_budget,
      sum(actual_cost) - sum(budget) as budget_overun
from cloud_cost_finops_cleaned group by department order by budget_overun;   


