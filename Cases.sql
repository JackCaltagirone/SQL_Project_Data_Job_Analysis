CREATE TABLE january_job AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_job AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_job AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

--created 3 new tables for jan feb march

SELECT job_posted_date
from january_job

--testing to see if functional


/*
Label new column 
anywhere = remote
new york = local
else = onsite
*/
SELECT
count(job_id) as number_of_jobs,
    case  
        when job_location = 'Anywhere' then 'remote'
        when job_location = 'New York, NY' then 'local'
        else 'onsite'
    end as Location_category 

FROM
    job_postings_fact

where
    job_title_short = 'Data Analyst'

GROUP BY
    Location_category


