-- 3A: Flag at-risk employees based on multiple factors
WITH risk_factors AS (
    SELECT
        employee_number,
        age,
        department,
        job_role,
        monthly_income,
        job_satisfaction,
        environment_satisfaction,
        work_life_balance,
        years_since_last_promotion,
        overtime,
        attrition,
        -- assign risk points
        CASE WHEN job_satisfaction <= 2        THEN 1 ELSE 0 END AS low_job_satisfaction,
        CASE WHEN environment_satisfaction <= 2 THEN 1 ELSE 0 END AS low_env_satisfaction,
        CASE WHEN work_life_balance <= 2        THEN 1 ELSE 0 END AS poor_work_life_balance,
        CASE WHEN years_since_last_promotion >= 3 THEN 1 ELSE 0 END AS stalled_promotion,
        CASE WHEN overtime = 'Yes'              THEN 1 ELSE 0 END AS doing_overtime,
        CASE WHEN monthly_income < 3000         THEN 1 ELSE 0 END AS low_income
    FROM hr_employees
),
risk_scored AS (
    SELECT
        *,
        (low_job_satisfaction + low_env_satisfaction +
         poor_work_life_balance + stalled_promotion +
         doing_overtime + low_income)            AS risk_score
    FROM risk_factors
)
SELECT
    employee_number,
    department,
    job_role,
    monthly_income,
    risk_score,
    CASE
        WHEN risk_score >= 4 THEN 'High Risk'
        WHEN risk_score >= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END                                         AS risk_level,
    attrition                                   AS actually_left
FROM risk_scored
ORDER BY risk_score DESC;


-- 3B: Risk level summary
WITH risk_factors AS (
    SELECT
        employee_number,
        attrition,
        CASE WHEN job_satisfaction <= 2         THEN 1 ELSE 0 END +
        CASE WHEN environment_satisfaction <= 2  THEN 1 ELSE 0 END +
        CASE WHEN work_life_balance <= 2         THEN 1 ELSE 0 END +
        CASE WHEN years_since_last_promotion >= 3 THEN 1 ELSE 0 END +
        CASE WHEN overtime = 'Yes'               THEN 1 ELSE 0 END +
        CASE WHEN monthly_income < 3000          THEN 1 ELSE 0 END AS risk_score
    FROM hr_employees
)
SELECT
    CASE
        WHEN risk_score >= 4 THEN 'High Risk'
        WHEN risk_score >= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END                                         AS risk_level,
    COUNT(*)                                    AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 
        ELSE 0 END)                             AS actually_left,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' 
        THEN 1 ELSE 0 END) / COUNT(*), 2)       AS actual_attrition_pct
FROM risk_factors
GROUP BY risk_level
ORDER BY actual_attrition_pct DESC;