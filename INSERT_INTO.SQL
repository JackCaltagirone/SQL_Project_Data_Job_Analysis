INSERT INTO job_applied (
        job_id,
        application_sent_date,
        custin_resume,
        resume_file_name,
        cover_letter_sent,
        cover_letter_file_name,
        status
    )
values (
        1,
        '2024-02-01',
        true,
        'resume_01.pdf',
        true,
        'cover_lettering_01.pdf',
        'submitted'
    ),
    (
        2,
        '2024-02-05',
        false,
        'resume_02.pdf',
        true,
        'cover_lettering_02.pdf',
        'in_review'
    ),
    (
        3,
        '2024-02-10',
        true,
        'resume_03.pdf',
        false,
        'cover_lettering_03.pdf',
        'submitted'
    ),
    (
        4,
        '2024-02-15',
        true,
        'resume_04.pdf',
        true,
        'cover_lettering_04.pdf',
        'approved'
    ),
    (
        5,
        '2024-02-20',
        false,
        'resume_05.pdf',
        false,
        'cover_lettering_05.pdf',
        'rejected'
    ),
    (
        6,
        '2024-02-25',
        true,
        'resume_06.pdf',
        true,
        'cover_lettering_06.pdf',
        'submitted'
    );

delete from job_applied
where job_id = 1;

SELECT *
from job_applied;