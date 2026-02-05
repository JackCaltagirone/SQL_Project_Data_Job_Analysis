SELECT*
    FROM
    (
        SELECT*
        FROM job_postings_fact
        WHERE EXTRACT(MONTH from job_posted_date) = 1
    )
    AS january_job;

--using a sub query i selected all from the database but only from january

with january_job as(
    SELECT * 
    from job_postings_fact 
    where EXTRACT(MONTH from job_posted_date) = 1
);

SELECT *
from january_job;

--same except using a cte

select * from company_dim limit 25

select name AS company_name
from company_dim   
where company_id in(
    select 
        company_id
    from    
        job_postings_fact
    where 
        job_no_degree_mention = true
);

/*
find the companys that have the most job offers
get tital number of job postings per company id
return the total number of jobs with the company name
*/


with company_job_count as(
    select
        company_id,
        count(*) as total_jobs
FROM
    job_postings_fact
GROUP BY
    company_id
)

select 
    company_dim.name as company_name,
    company_job_count.total_jobs
from
    company_dim
left join company_job_count on company_job_count.company_id = company_dim.company_id
ORDER BY
total_jobs desc
