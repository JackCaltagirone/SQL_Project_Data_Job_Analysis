SELECT 
    job_title_short AS Title,
    job_location as Location,
    job_posted_date at time zone 'utc' at time zone 'est' as date_time,
    EXTRACT(MONTH FROM job_posted_date) as date_month

    FROM job_postings_fact

    limit 100


SELECT
    COUNT (job_id),
    EXTRACT(MONTH from job_posted_date) as MONTH

FROM
    job_postings_fact

where  
    job_title_short = 'Data Analyst'

group by
    MONTH
limit 100

SELECT* from job_postings_fact limit 1


/*
write a query to find the average salary both yearly and hourly for job postings that were posted after jun 1, 2023 group results by job schedule type
salary_year_Avg salary_hour_avg job_schedule_type
from job_posted_Fact
*/

SELECT
    job_schedule_type,
    round(AVG(salary_year_avg), 2) AS avg_yearly_salary,
    round(AVG(salary_hour_avg), 2) AS avg_hourly_salary
FROM job_postings_fact
WHERE job_posted_date > '2023-06-01'
GROUP BY job_schedule_type;

/*
WRITE A query to count the number of job posting for each month in 2023, adjusting the job_posted_date to be in America/new York time zone. before extracting the month.
assume the job_posted_date is stored in the utc group by and order by the month
*/

SELECT
    DATE_TRUNC('month', job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(*) AS postings_count
FROM job_postings_fact
WHERE (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') 
      BETWEEN '2023-01-01' AND '2023-12-31 23:59:59'
GROUP BY month
ORDER BY month;

