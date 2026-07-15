-- 1A: Overall attrition rate
SELECT
    attrition,
    COUNT(*)                                    AS employee_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) 
    OVER(), 2)                                  AS attrition_rate_pct
FROM hr_employees
GROUP BY attrition;


-- 1B: Attrition by Department
SELECT
    department,
    COUNT(*)                                    AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 
        ELSE 0 END)                             AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' 
        THEN 1 ELSE 0 END) / COUNT(*), 2)       AS attrition_rate_pct
FROM hr_employees
GROUP BY department
ORDER BY attrition_rate_pct DESC;


-- 1C: Attrition by Job Role
SELECT
    job_role,
    COUNT(*)                                    AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 
        ELSE 0 END)                             AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' 
        THEN 1 ELSE 0 END) / COUNT(*), 2)       AS attrition_rate_pct
FROM hr_employees
GROUP BY job_role
ORDER BY attrition_rate_pct DESC;


-- 1D: Attrition by Years at Company (tenure bands)
SELECT
    CASE
        WHEN years_at_company <= 2  THEN '0-2 years'
        WHEN years_at_company <= 5  THEN '3-5 years'
        WHEN years_at_company <= 10 THEN '6-10 years'
        ELSE '10+ years'
    END                                         AS tenure_band,
    COUNT(*)                                    AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 
        ELSE 0 END)                             AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' 
        THEN 1 ELSE 0 END) / COUNT(*), 2)       AS attrition_rate_pct
FROM hr_employees
GROUP BY tenure_band
ORDER BY attrition_rate_pct DESC;