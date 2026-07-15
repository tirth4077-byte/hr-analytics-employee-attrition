-- ============================================================
-- MODULE 4: KPI VIEWS (Power BI connects to these)
-- ============================================================

-- VIEW 1: Attrition Summary by Department and Role
CREATE OR REPLACE VIEW vw_attrition_summary AS
SELECT
    department,
    job_role,
    gender,
    marital_status,
    COUNT(*)                                        AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 
        ELSE 0 END)                                 AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes'
        THEN 1 ELSE 0 END) / COUNT(*), 2)           AS attrition_rate_pct
FROM hr_employees
GROUP BY department, job_role, gender, marital_status
ORDER BY attrition_rate_pct DESC;


-- VIEW 2: Salary and Performance Analysis
CREATE OR REPLACE VIEW vw_salary_performance AS
SELECT
    department,
    job_role,
    job_level,
    gender,
    ROUND(AVG(monthly_income)::NUMERIC, 2)          AS avg_monthly_income,
    ROUND(AVG(percent_salary_hike)::NUMERIC, 2)     AS avg_salary_hike_pct,
    ROUND(AVG(performance_rating)::NUMERIC, 2)      AS avg_performance_rating,
    ROUND(AVG(total_working_years)::NUMERIC, 2)     AS avg_working_years,
    COUNT(*)                                        AS total_employees
FROM hr_employees
GROUP BY department, job_role, job_level, gender
ORDER BY avg_monthly_income DESC;


-- VIEW 3: At-Risk Employees
CREATE OR REPLACE VIEW vw_at_risk_employees AS
WITH risk_scored AS (
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
        CASE WHEN job_satisfaction <= 2          THEN 1 ELSE 0 END +
        CASE WHEN environment_satisfaction <= 2   THEN 1 ELSE 0 END +
        CASE WHEN work_life_balance <= 2          THEN 1 ELSE 0 END +
        CASE WHEN years_since_last_promotion >= 3 THEN 1 ELSE 0 END +
        CASE WHEN overtime = 'Yes'                THEN 1 ELSE 0 END +
        CASE WHEN monthly_income < 3000           THEN 1 ELSE 0 END AS risk_score
    FROM hr_employees
)
SELECT
    employee_number,
    age,
    department,
    job_role,
    monthly_income,
    risk_score,
    CASE
        WHEN risk_score >= 4 THEN 'High Risk'
        WHEN risk_score >= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END                                             AS risk_level,
    attrition                                       AS actually_left
FROM risk_scored
ORDER BY risk_score DESC;


-- VIEW 4: Workforce Overview KPIs
CREATE OR REPLACE VIEW vw_workforce_kpi AS
SELECT
    department,
    job_role,
    ROUND(AVG(age)::NUMERIC, 1)                     AS avg_age,
    ROUND(AVG(monthly_income)::NUMERIC, 2)          AS avg_monthly_income,
    ROUND(AVG(years_at_company)::NUMERIC, 1)        AS avg_tenure,
    ROUND(AVG(job_satisfaction)::NUMERIC, 2)        AS avg_job_satisfaction,
    ROUND(AVG(work_life_balance)::NUMERIC, 2)       AS avg_work_life_balance,
    ROUND(AVG(environment_satisfaction)::NUMERIC, 2) AS avg_env_satisfaction,
    ROUND(AVG(performance_rating)::NUMERIC, 2)      AS avg_performance_rating,
    COUNT(*)                                        AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 
        ELSE 0 END)                                 AS total_attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes'
        THEN 1 ELSE 0 END) / COUNT(*), 2)           AS attrition_rate_pct
FROM hr_employees
GROUP BY department, job_role
ORDER BY attrition_rate_pct DESC;


-- Verify all views created
SELECT table_name
FROM information_schema.views
WHERE table_schema = 'public'
ORDER BY table_name;