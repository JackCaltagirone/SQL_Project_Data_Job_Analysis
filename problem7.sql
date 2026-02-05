/*find the count of the number of remote job posting per skill
    Display the top 5 skills by their demand in remote jobs
    include sjill ID, name, and count of the posting requriring the skill
*/

SELECT * from skills_job_dim limit 20;


with remote_job_skills as
(
    SELECT
        skill_id,  --each skill has skill id 
        count(*) as skill_count   --the amount of postings with each skill id

    FROM
        skills_job_dim as skills_to_job -- this table only has job_id and skill_id

    INNER JOIN job_postings_fact as job_postings on job_postings.job_id = skills_to_job.job_id
-- joins the skills with the job using the primary key of job_id
    where   
        job_postings.job_work_from_home = true  -- we only want work from home jobs for this 

    group by
        skill_id
) 

SELECT
    skills.skill_id,
    skills as skill_name,
    skill_count

from remote_job_skills

INNER JOIN skills_dim as skills on skills.skill_id = remote_job_skills.skill_id

ORDER BY skill_count desc

limit 5