--get jobs from january

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_job

UNION ALL

--get the jobs from febuary

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_job

UNION ALL

SELECT
    job_title_short,
    company_id ,
    job_location

FROM
    february_job