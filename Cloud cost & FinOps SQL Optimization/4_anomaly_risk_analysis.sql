use cloud_cost_finops;
select * from cloud_cost_finops_cleaned;

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
