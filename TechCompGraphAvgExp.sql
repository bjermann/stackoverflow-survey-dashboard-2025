DROP TABLE TechCompGraphAvgExp;

SELECT *
FROM TechCompGraphAvgExp
ORDER BY MedianSalary DESC;

--Creating a table to create a graph on Power BI that shows median salary for each DevType, average work experience and number of respondents
CREATE TABLE TechCompGraphAvgExp (
    DevType NVARCHAR(100) NOT NULL PRIMARY KEY,
    AvgExperience INT NULL,
    MedianSalary INT NULL,
    RespondentCount INT NOT NULL
);

--Populating the table with data from Breaking_into_Tech
--Group by DevType, show the median salary and average or median years of experience along with how many people answered the survey
INSERT INTO TechCompGraphAvgExp (DevType, AvgExperience, MedianSalary, RespondentCount)
SELECT
    DevType,
    AVG(WorkExp) AS AvgExperience,
    MedianSalary,
    COUNT(*) AS RespondentCount
FROM (
    SELECT
        DevType,
        WorkExp,
        CompTotal,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CompTotal)
            OVER (PARTITION BY DevType) AS MedianSalary
    FROM breaking_into_tech
    WHERE DevType IS NOT NULL
      AND WorkExp IS NOT NULL
      AND CompTotal IS NOT NULL
      AND CompTotal > 0
      AND WorkExp >= 0
      AND Country = 'United States of America'
      AND Currency = 'USD United States dollar'
) t
GROUP BY DevType, MedianSalary
HAVING COUNT(*) >= 10;