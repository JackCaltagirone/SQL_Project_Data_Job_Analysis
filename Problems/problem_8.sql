/*
find job postings from the first quarter that have a salary greater than 70k.
- Combine job posting tables from the frist quarter of 2023 - jan march
-gets jobs posting with and average yearlys salary >70k
*/


SELECT 
    Q1_job.job_title_short,
    Q1_job.job_location,
    Q1_job.job_via,
    Q1_job.job_posted_date::DATE,
    q1_job.salary_year_avg

FROM(

    SELECT *
    from january_job

    union ALL

    select *
    FROM february_job

    UNION ALL

    select * 
    FROM march_job

    ) as Q1_job

WHERE
    q1_job.salary_year_avg > 70000 and q1_job.job_title_short = 'Data Analyst'

ORDER BY
    q1_job.salary_year_avg DESC
