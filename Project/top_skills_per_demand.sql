/* 
What are the most optimal skills to learn?
Goal: Identify skills that are BOTH high‑demand and high‑paying.

Steps:
1. Join job postings to their required skills.
2. Compute demand: how often each skill appears.
3. Compute pay: average normalized salary for jobs requiring that skill.
4. Rank skills separately by demand and salary.
5. Return skills that rank highly in BOTH categories.
*/

WITH job_skill_data AS (
    SELECT
        SD.skills,
        -- Normalize salary so hourly and yearly can be compared
        COALESCE(JPF.salary_year_avg, JPF.salary_hour_avg * 2080) AS salary
    FROM job_postings_fact AS JPF
    JOIN skills_job_dim AS SJD 
        ON JPF.job_id = SJD.job_id
    JOIN skills_dim AS SD
        ON SJD.skill_id = SD.skill_id
    WHERE COALESCE(JPF.salary_year_avg, JPF.salary_hour_avg * 2080) IS NOT NULL
),

skill_stats AS (
    SELECT
        skills,
        COUNT(*) AS demand_count,      -- how often the skill appears
        AVG(salary) AS avg_salary      -- average salary for jobs requiring the skill
    FROM job_skill_data
    GROUP BY skills
),

ranked_skills AS (
    SELECT
        skills,
        demand_count,
        avg_salary,
        -- Rank skills by demand (descending)
        RANK() OVER (ORDER BY demand_count DESC) AS demand_rank,
        -- Rank skills by salary (descending)
        RANK() OVER (ORDER BY avg_salary DESC) AS salary_rank
    FROM skill_stats
)

-- Final output: skills that are BOTH high‑demand and high‑paying
SELECT
    skills,
    demand_count,
    avg_salary,
    demand_rank,
    salary_rank
FROM ranked_skills
ORDER BY demand_rank + salary_rank ASC   -- still sorts by "best overall" but no score column
LIMIT 20;