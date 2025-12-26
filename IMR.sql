use portfolio_projects;

select *
from imr;

ALTER TABLE imr
CHANGE COLUMN `states/uts` `state` VARCHAR(100);

ALTER TABLE imr
CHANGE COLUMN `year` `years` int;


#1.What is the overall trend in mortality rate over the years across all states?

select years, avg(imr) as mortality_rate
from imr
group by years
order by mortality_rate

#2. 2. States with highest and lowest mortality rates
# Highest

SELECT state, AVG(imr) AS avg_rate
FROM imr
GROUP BY state
ORDER BY avg_rate DESC
LIMIT 10;

#Lowest
SELECT state, AVG(imr) AS avg_rate
FROM mortality
GROUP BY state
ORDER BY avg_rate ASC
LIMIT 10;

✅ 3. Mortality variation by region
SELECT 
    region,
    AVG(imr) AS avg_rate
FROM imr
GROUP BY region
ORDER BY avg_rate;

✅ 4. Detect sudden spike/drop in states across years
SELECT 
    state,
    years,
    imr,
    LAG(imr) OVER (PARTITION BY state ORDER BY years) AS previous_year_rate,
    imr - LAG(imr) OVER (PARTITION BY state ORDER BY years) AS change_in_rate
FROM imr
ORDER BY ABS(change_in_rate) DESC;

✅ 5. Variability between states in a given year
SELECT 
    years,
    MAX(imr) - MIN(imr) AS difference,
    STDDEV(imr) AS variability
FROM imr
GROUP BY years
ORDER BY years;

✅ 6. States with biggest improvement/decline in rank
SELECT
    state,
    MIN(rank) AS best_rank,
    MAX(rank) AS worst_rank,
    MAX(rank) - MIN(rank) AS rank_change
FROM imr
GROUP BY state
ORDER BY rank_change DESC;

 7. Years with unusual patterns
SELECT 
    years,
    AVG(imr) AS avg_rate,
    AVG(imr) - 
    (SELECT AVG(imr) FROM imr) AS deviation_from_overall
FROM mortality
GROUP BY year
ORDER BY ABS(deviation_from_overall) DESC;

 8. Check missing values
SELECT 
    SUM(CASE WHEN state IS NULL THEN 1 END) AS missing_state,
    SUM(CASE WHEN years IS NULL THEN 1 END) AS missing_year,
    SUM(CASE WHEN region IS NULL THEN 1 END) AS missing_region,
    SUM(CASE WHEN imr IS NULL THEN 1 END) AS missing_mortality_rate
FROM imr;

9. Identify regions needing intervention (highest avg mortality)
SELECT 
    region,
    AVG(imr) AS avg_mortality_rate
FROM imr
GROUP BY region
ORDER BY avg_mortality_rate DESC;

10. Are there any years with significant IMR spike/drop across states?
SELECT 
    years,
    AVG(imr) AS avg_imr,
    AVG(imr) - (SELECT AVG(imr) FROM imr) AS deviation_from_overall
FROM imr
GROUP BY years
ORDER BY ABS(deviation_from_overall) DESC;

11. How much inequality exists between states in a given year?
SELECT 
    years,
    MAX(imr) AS highest_imr,
    MIN(imr) AS lowest_imr,
    MAX(imr) - MIN(imr) AS gap_between_states,
    STDDEV(imr) AS imr_variability
FROM imr
GROUP BY years
ORDER BY years;