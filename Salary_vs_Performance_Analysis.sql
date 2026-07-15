-- 2A: Avg Salary by Department
SELECT
    department,
    ROUND(AVG(monthly_income)::NUMERIC, 2)      AS avg_monthly_income,
    ROUND(AVG(percent_salary_hike)::NUMERIC, 2) AS avg_salary_hike_pct,
    ROUND(AVG(performance_rating)::NUMERIC, 2)  AS avg_performance_rating
FROM hr_employees
GROUP BY department
ORDER BY avg_monthly_income DESC;


-- 2B: Salary vs Performance by Job Role
SELECT
    job_role,
    ROUND(AVG(monthly_income)::NUMERIC, 2)      AS avg_monthly_income,
    ROUND(AVG(percent_salary_hike)::NUMERIC, 2) AS avg_salary_hike_pct,
    ROUND(AVG(performance_rating)::NUMERIC, 2)  AS avg_performance_rating,
    COUNT(*)                                    AS total_employees
FROM hr_employees
GROUP BY job_role
ORDER BY avg_monthly_income DESC;


-- 2C: Salary by Gender (pay equity check)
SELECT
    gender,
    department,
    ROUND(AVG(monthly_income)::NUMERIC, 2)      AS avg_monthly_income,
    COUNT(*)                                    AS total_employees
FROM hr_employees
GROUP BY gender, department
ORDER BY department, gender;


-- 2D: Salary hike vs Performance rating
SELECT
    performance_rating,
    ROUND(AVG(percent_salary_hike)::NUMERIC, 2) AS avg_salary_hike_pct,
    ROUND(AVG(monthly_income)::NUMERIC, 2)      AS avg_monthly_income,
    COUNT(*)                                    AS total_employees
FROM hr_employees
GROUP BY performance_rating
ORDER BY performance_rating DESC;