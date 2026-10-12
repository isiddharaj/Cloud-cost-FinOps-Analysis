use cloud_cost_finops;
select * from cloud_cost_finops_cleaned;

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
      
