
DROP TABLE IF EXISTS developer_survey;

CREATE TABLE developer_survey (
    ResponseId TEXT,
    Country TEXT,
    WorkExp TEXT,
    RemoteWork TEXT,
    ConvertedCompYearly TEXT,
    LanguageHaveWorkedWith TEXT,
    DatabaseHaveWorkedWith TEXT,
    PlatformHaveWorkedWith TEXT
);

SELECT * FROM developer_survey;

SELECT COUNT(*) FROM developer_survey;

SELECT * FROM developer_survey
LIMIT 5;


-- Global Median Salary Analysis
-- Using PERCENTILE_CONT to calculate median salary

SELECT
ROUND(
PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY ConvertedCompYearly::NUMERIC
)
) AS Global_Median_Salary
FROM developer_survey
WHERE ConvertedCompYearly <> 'nan';


-- Salary by Experience
-- Requirement: Experience vs Salary 

SELECT
CASE
WHEN WorkExp::INT <= 2 THEN '0-2 Years'
WHEN WorkExp::INT <= 5 THEN '3-5 Years'
WHEN WorkExp::INT <= 10 THEN '6-10 Years'
WHEN WorkExp::INT <= 15 THEN '11-15 Years'
ELSE '15+ Years'
END AS Experience_Level,

ROUND(
PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY ConvertedCompYearly::NUMERIC
)
) AS Median_Salary

FROM developer_survey

WHERE
WorkExp <> 'nan'
AND ConvertedCompYearly <> 'nan'

GROUP BY Experience_Level

ORDER BY Median_Salary DESC;

-- Salary by Country
-- Requirement: Cross-tabulate by Country

SELECT Country,
ROUND(PERCENTILE_CONT(0.5)
WITHIN GROUP(
ORDER BY ConvertedCompYearly::NUMERIC)) 

AS Median_Salary

FROM developer_survey

WHERE ConvertedCompYearly <> 'nan'

GROUP BY Country

HAVING COUNT(*) > 50

ORDER BY Median_Salary DESC;

-- Salary by Remote Work Status
-- Requirement: Cross-tabulate by Remote Work

SELECT
RemoteWork,
ROUND(
PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY ConvertedCompYearly::NUMERIC)) 
AS Median_Salary

FROM developer_survey

WHERE ConvertedCompYearly <> 'nan'

GROUP BY RemoteWork

ORDER BY Median_Salary DESC;

-- ARRAY + STRING SPLITTING
-- Requirement: ARRAY

SELECT

ResponseId,

STRING_TO_ARRAY(LanguageHaveWorkedWith,';') AS Language_Array

FROM developer_survey

LIMIT 10;

-- UNNEST
-- Requirement: UNNEST

SELECT

ResponseId,

UNNEST(STRING_TO_ARRAY(LanguageHaveWorkedWith,';')) AS Language

FROM developer_survey

LIMIT 20;

-- Highest Paying Programming Languages
-- Requirement: Technology Stack Analysis

WITH Languages AS (

SELECT

ConvertedCompYearly::NUMERIC AS Salary,

UNNEST(STRING_TO_ARRAY(LanguageHaveWorkedWith,';')) AS Language

FROM developer_survey

WHERE
LanguageHaveWorkedWith IS NOT NULL
AND ConvertedCompYearly <> 'nan')

SELECT

Language,

COUNT(*) AS Developers,

ROUND(PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY Salary)) AS Median_Salary

FROM Languages

GROUP BY Language

HAVING COUNT(*) > 100

ORDER BY Median_Salary DESC;

-- Highest Paying Databases

WITH Databases AS (

SELECT

ConvertedCompYearly::NUMERIC AS Salary,

UNNEST(
STRING_TO_ARRAY(DatabaseHaveWorkedWith,';')) AS Database_Name

FROM developer_survey

WHERE
DatabaseHaveWorkedWith IS NOT NULL
AND ConvertedCompYearly <> 'nan'
)

SELECT

Database_Name,

ROUND(PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY Salary)) AS Median_Salary

FROM Databases

GROUP BY Database_Name

HAVING COUNT(*) > 100

ORDER BY Median_Salary DESC;

-- Highest Paying Platforms

WITH Platforms AS (

SELECT

ConvertedCompYearly::NUMERIC AS Salary,

UNNEST(
STRING_TO_ARRAY(PlatformHaveWorkedWith,';')) AS Platform

FROM developer_survey

WHERE
PlatformHaveWorkedWith IS NOT NULL
AND ConvertedCompYearly <> 'nan'
)

SELECT

Platform,

ROUND(PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY Salary)) AS Median_Salary

FROM Platforms

GROUP BY Platform

HAVING COUNT(*) > 100

ORDER BY Median_Salary DESC;

-- Final Project Query

WITH Languages AS (

SELECT

WorkExp,

ConvertedCompYearly::NUMERIC AS Salary,

UNNEST(
STRING_TO_ARRAY(
LanguageHaveWorkedWith,
';'
)
) AS Language

FROM developer_survey

WHERE
WorkExp <> 'nan'
AND ConvertedCompYearly <> 'nan'

)

SELECT

Language,

CASE
WHEN WorkExp::INT <= 2 THEN '0-2 Years'
WHEN WorkExp::INT <= 5 THEN '3-5 Years'
WHEN WorkExp::INT <= 10 THEN '6-10 Years'
WHEN WorkExp::INT <= 15 THEN '11-15 Years'
ELSE '15+ Years'
END AS Experience_Level,

ROUND(
PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY Salary
)
) AS Median_Salary

FROM Languages

GROUP BY
Language,
Experience_Level

HAVING COUNT(*) > 30

ORDER BY Median_Salary DESC;

--- Key insights

-- 1. Top 5 Highest Paying Programming Languages


WITH Languages AS (

SELECT

ConvertedCompYearly::NUMERIC AS Salary,

UNNEST(
STRING_TO_ARRAY(
LanguageHaveWorkedWith,
';'
)
) AS Language

FROM developer_survey

WHERE
LanguageHaveWorkedWith IS NOT NULL
AND ConvertedCompYearly <> 'nan'

)

SELECT

Language,

COUNT(*) AS Developer_Count,

ROUND(
PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY Salary
)
) AS Median_Salary

FROM Languages

GROUP BY Language

HAVING COUNT(*) > 100

ORDER BY Median_Salary DESC

LIMIT 5;


-- 2. Top 5 Highest Paying Databases

WITH Databases AS (

SELECT

ConvertedCompYearly::NUMERIC AS Salary,

UNNEST(
STRING_TO_ARRAY(
DatabaseHaveWorkedWith,
';'
)
) AS Database_Name

FROM developer_survey

WHERE
DatabaseHaveWorkedWith IS NOT NULL
AND ConvertedCompYearly <> 'nan'

)

SELECT

Database_Name,

COUNT(*) AS Developer_Count,

ROUND(
PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY Salary
)
) AS Median_Salary

FROM Databases

GROUP BY Database_Name

HAVING COUNT(*) > 100

ORDER BY Median_Salary DESC

LIMIT 5;


-- 3. Top 5 Highest Paying Platforms

WITH Platforms AS (

SELECT

ConvertedCompYearly::NUMERIC AS Salary,

UNNEST(
STRING_TO_ARRAY(
PlatformHaveWorkedWith,
';'
)
) AS Platform

FROM developer_survey

WHERE
PlatformHaveWorkedWith IS NOT NULL
AND ConvertedCompYearly <> 'nan'

)

SELECT

Platform,

COUNT(*) AS Developer_Count,

ROUND(
PERCENTILE_CONT(0.5)
WITHIN GROUP (
ORDER BY Salary
)
) AS Median_Salary

FROM Platforms

GROUP BY Platform

HAVING COUNT(*) > 100

ORDER BY Median_Salary DESC

LIMIT 5;






