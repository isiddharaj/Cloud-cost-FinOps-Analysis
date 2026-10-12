use cloud_cost_finops;
select * from cloud_cost_finops_cleaned;

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

-- Q6. Which services have the greatest savings opportunity?
select service,
      sum(potential_savings) as potential_savings
from cloud_cost_finops_cleaned group by service order by potential_savings desc;

