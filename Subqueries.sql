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
)

SELECT *
from january_job

--same except using a cte
