with SalaryCombine AS (
    SELECT
        job_title_short,
        salary_year_avg,
        salary_hour_avg,
        COALESCE(salary_year_avg, salary_hour_avg * 2080) AS effective_salary
    FROM
        job_postings_fact
)

SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    SalaryCombine.effective_salary
FROM
    SalaryCombine

ORDER BY 
    effective_salary DESC NULLS LAST

LIMIT 10;


SELECT
    job_title_short,
    Count(*) AS Job_count

from
    job_postings_fact

group by
    job_title_short

ORDER BY
    Job_count DESC

LIMIT 10;


SELECT
    job_title_short,
    Round(avg(salary_year_avg),2) as salary_avg,
    Round(avg(salary_hour_avg), 2) as salary_avg_hour,
    Round(avg(COALESCE(salary_year_avg, salary_hour_avg * 2080)), 2) AS effective_salary_avg

from
    job_postings_fact

group by
    job_title_short

ORDER by
    effective_salary_avg DESC NULLS LAST

    
LIMIT 10;




