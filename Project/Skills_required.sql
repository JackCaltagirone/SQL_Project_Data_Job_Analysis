/* 
What skills are required for those top paying jobs?

1. Identify the top 50 highest‑paying jobs (yearly or hourly normalized).
2. Find the skills required for those jobs.
3. Attach readable skill names.
4. Rank job titles per skill to find:
      - the most common job for each skill
      - the highest salary for that job
*/

WITH top_jobs AS (
    SELECT 
        JPF.job_id,
        JPF.job_title_short,
        JPF.salary_year_avg,
        JPF.salary_hour_avg
    FROM job_postings_fact AS JPF
    -- Normalize salary so hourly and yearly can be compared fairly
    ORDER BY COALESCE(JPF.salary_year_avg, JPF.salary_hour_avg * 2080) DESC NULLS LAST
    LIMIT 50   -- Keep only the top 50 highest‑paying jobs
),

top_skills AS (
    SELECT 
        SJD.job_id,
        SJD.skill_id
    FROM top_jobs
    -- Link each top job to the skills required for that job
    INNER JOIN skills_job_dim AS SJD 
        ON top_jobs.job_id = SJD.job_id
),

connected_skills AS (
    SELECT 
        SD.skill_id,
        SD.skills
    FROM top_skills
    -- Convert skill_id → readable skill name
    JOIN skills_dim AS SD 
        ON top_skills.skill_id = SD.skill_id
),

-- Combine job title, normalized salary, and skill name into one table
all_data AS (
    SELECT
        tj.job_title_short,
        COALESCE(tj.salary_year_avg, tj.salary_hour_avg * 2080) AS salary,
        cs.skills
    FROM top_skills ts
    JOIN top_jobs tj ON ts.job_id = tj.job_id
    JOIN connected_skills cs ON ts.skill_id = cs.skill_id
),

-- For each skill, rank job titles by:
--   1. how often they appear (most common job)
--   2. highest salary (tie‑breaker)
job_rank AS (
    SELECT
        skills,
        job_title_short,
        COUNT(*) AS job_count,        -- how many top jobs use this skill + job title combo
        MAX(salary) AS highest_salary, -- highest salary for that job title
        ROW_NUMBER() OVER (
            PARTITION BY skills
            ORDER BY COUNT(*) DESC, MAX(salary) DESC
        ) AS rn                       -- pick the top job per skill
    FROM all_data
    GROUP BY skills, job_title_short
)

-- Final output:
--   - total number of top jobs requiring each skill
--   - the most common job title for that skill
--   - the highest salary for that job title
SELECT
    skills,
    SUM(job_count) AS total_job_count,
    job_title_short AS most_common_job,
    highest_salary AS highest_salary_for_that_job
FROM job_rank
WHERE rn = 1   -- keep only the top-ranked job per skill
GROUP BY skills, job_title_short, highest_salary
ORDER BY total_job_count DESC;