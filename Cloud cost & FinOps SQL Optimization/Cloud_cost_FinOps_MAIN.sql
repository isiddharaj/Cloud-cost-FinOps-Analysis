create database cloud_cost_finops;
use cloud_cost_finops;

--
SELECT COUNT(*) AS total_rows
FROM cloud_cost_finops_cleaned;

--
describe cloud_cost_finops_cleaned;


-- Check duplicate transaction IDs
SELECT transaction_id, COUNT(*) AS count
FROM cloud_cost_finops_cleaned
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Check NULLs
SELECT
    SUM(region IS NULL) AS missing_region,
    SUM(project IS NULL) AS missing_project,
    SUM(cost_center IS NULL) AS missing_cost_center
FROM cloud_cost_finops;

-- Check negative costs
SELECT COUNT(*) AS negative_costs
FROM cloud_cost_finops_cleaned
WHERE actual_cost < 0;

-- Check invalid utilization
SELECT COUNT(*) AS invalid_utilization
FROM cloud_cost_finops_cleaned
WHERE utilization_rate < 0
   OR utilization_rate > 100;
  
-- Check anomaly records
SELECT
    anomaly_flag,
    COUNT(*) AS records
FROM cloud_cost_finops_cleaned
GROUP BY anomaly_flag;   

-----  \\\\ ||||||||| ////  -----

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


-- Page 2 — Cost Drivers

-- Q1. Which services contribute the most to cloud cost?
select service,
	  sum(actual_cost) as total_cost
from cloud_cost_finops_cleaned group by service order by total_cost desc;    

-- Q2. Which departments have the highest cloud costs?
 select department,
       sum(actual_cost) as total_cost
from cloud_cost_finops_cleaned group by department order by total_cost desc;       

-- Q3. Which environments consume the most money?
select environment,
      sum(actual_cost) as total_cost
from cloud_cost_finops_cleaned group by environment order by total_cost desc;     

-- Q4. Which projects are the most expensive?
select project,
      sum(actual_cost) as total_cost
from cloud_cost_finops_cleaned group by project order by total_cost desc;   

-- Q5. Which service + department combination has the highest cost?(Top 10)
select service,department,
      sum(actual_cost) as total_cost
from cloud_cost_finops_cleaned group by service,department order by total_cost desc limit 10;  
  
-- Q6. What percentage of total spending comes from each service?
select service,
      sum(actual_cost) as service_cost,
      round(
            sum(actual_cost)*100/
            (select sum(actual_cost) from cloud_cost_finops_cleaned),2
      ) as total_percentage
      from cloud_cost_finops_cleaned group by service order by total_percentage desc;
      
      
-- Page 3 — Cost Optimization
  
-- Q1. How much potential savings are available?
select 
      sum(budget) - sum(actual_cost) as potential_saving
from cloud_cost_finops_cleaned;

-- Q2. Which resource statuses have the highest potential savings?
select resource_status,
       sum(budget) - sum(actual_cost) as potential_saving
from cloud_cost_finops_cleaned group by resource_status order by potential_saving desc;        

-- Q3. Which resources are idle?     
select resource_id,
       service,
       department,
       project,
       actual_cost,
       potential_savings
from cloud_cost_finops_cleaned where resource_status='idle' order by potential_savings desc;  

-- Q4. Which resources are underutilized but expensive?
select resource_id,
	   department,
       service,
       utilization_rate,
       actual_cost
from cloud_cost_finops_cleaned where resource_status = 'underutilized' order by actual_cost desc; 

-- Q5. Which departments have the highest optimization potential?     
select department,
      sum(actual_cost) as current_cost,
      sum(potential_savings) as potential_savings
from cloud_cost_finops_cleaned group by department order by potential_savings desc;  

select * from cloud_cost_finops_cleaned;
-- Q6. Which services have the greatest savings opportunity?
select service,
      sum(potential_savings) as potential_savings
from cloud_cost_finops_cleaned group by service order by potential_savings desc;
 
 
-- Page 4 — Anomaly & Risk Analysis
 
-- Q1. How many anomalous transactions are there?
select
      count(*) as anomaly_count
from cloud_cost_finops_cleaned where anomaly_flag='Yes';

-- Q2. How much money is associated with anomalies?
SELECT
      sum(actual_cost) as anomaly_cost 
from cloud_cost_finops_cleaned where anomaly_flag='Yes';

-- Q3. Which services have the highest anomaly cost?
select service,
      sum(actual_cost) as anomaly_cost
from cloud_cost_finops_cleaned where anomaly_flag='Yes' group by service order by anomaly_cost desc;

-- Q4. Which departments have the highest anomaly cost?
select department,
      sum(actual_cost) as anomaly_cost
from cloud_cost_finops_cleaned where anomaly_flag='Yes' group by department order by anomaly_cost desc;

-- Q5. When did anomaly spending occur?
select date,
      count(*) as anomaly_count,
      sum(actual_cost) as anomaly_cost
from cloud_cost_finops_cleaned where anomaly_flag='Yes'group by date order by date;
