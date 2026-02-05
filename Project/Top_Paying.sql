/* 
Top paying Data Analyst jobs

1. Show the highest‑paying full‑time Data Analyst roles.
   - Salary may be yearly or hourly, so we normalize using COALESCE.

2. Only include jobs posted within the last 3 months of the dataset.
   - Dataset is old, so we dynamically detect the newest posting date.

3. Only include jobs located in New York OR fully remote.

4. Join in company names from company_dim using company_id.
*/

-- Step 1: Find the most recent job posting date in the entire dataset.
-- This replaces NOW() because the dataset is historical.
WITH latest AS (
    SELECT MAX(job_posted_date) AS max_date
    FROM job_postings_fact
),

-- Step 2: Filter jobs based on role, schedule, location, and recency.
-- CROSS JOIN brings latest.max_date into this CTE so we can compare dates.
filter1 AS (
    SELECT 
        j.job_title_short,
        j.job_posted_date,
        j.job_work_from_home,
        j.salary_year_avg,
        j.salary_hour_avg,
        j.company_id
    FROM job_postings_fact AS j
    CROSS JOIN latest   -- Makes latest.max_date available inside this query

    WHERE j.job_schedule_type = 'Full-time'
      AND j.job_title_short = 'Data Analyst'
      AND (
            j.job_location ILIKE 'new-york'
            OR j.job_work_from_home = true
          )
      -- Only include jobs within 3 months of the dataset's newest posting
      AND j.job_posted_date >= latest.max_date - INTERVAL '3 months'
)

-- Step 3: Join filtered jobs with company_dim to attach company names.
SELECT 
    f.job_title_short,
    f.job_posted_date,
    f.job_work_from_home,
    f.salary_year_avg,
    f.salary_hour_avg,
    c.name AS company_name
FROM filter1 AS f
LEFT JOIN company_dim AS c 
    ON f.company_id = c.company_id   -- Match job to its company

-- Step 4: Sort by highest effective salary.
-- If yearly salary is missing, convert hourly to yearly (hourly * 2080).
ORDER BY COALESCE(f.salary_year_avg, f.salary_hour_avg * 2080) DESC NULLS LAST

LIMIT 50;