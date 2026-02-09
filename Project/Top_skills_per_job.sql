/* 
What are the most in‑demand skills for each job title?

Goal:
1. List every unique job_title_short.
2. Count how often each skill appears for that role.
3. Rank skills by demand.
4. Return the top 3 skills per job title.
*/

WITH job_skill_counts AS (
    SELECT
        JPF.job_title_short,
        SD.skills,
        COUNT(*) AS skill_count
    FROM job_postings_fact AS JPF
    -- Link each job posting to its required skills
    JOIN skills_job_dim AS SJD 
        ON JPF.job_id = SJD.job_id
    JOIN skills_dim AS SD
        ON SJD.skill_id = SD.skill_id
    GROUP BY JPF.job_title_short, SD.skills
),

ranked_skills AS (
    SELECT
        job_title_short,
        skills,
        skill_count,
        -- Rank skills per job title by how often they appear
        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY skill_count DESC
        ) AS rn
    FROM job_skill_counts
)

-- Final output: one row per job title, showing its top 3 skills
SELECT
    job_title_short,
    MAX(CASE WHEN rn = 1 THEN skills END) AS top_skill_1,
    MAX(CASE WHEN rn = 2 THEN skills END) AS top_skill_2,
    MAX(CASE WHEN rn = 3 THEN skills END) AS top_skill_3
FROM ranked_skills
WHERE rn <= 3
GROUP BY job_title_short
ORDER BY job_title_short;