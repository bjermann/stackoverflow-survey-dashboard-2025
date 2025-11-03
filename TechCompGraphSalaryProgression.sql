-- Pull raw data for Power BI to calculate medians dynamically
-- This approach is better than pre-calculating medians in SQL

DROP TABLE IF EXISTS TechCompRawData;

SELECT *
FROM [Break into Tech Project].[dbo].[TechCompRawData]
ORDER BY DevType, ExperienceRange;

-- Create table to store raw filtered data
CREATE TABLE TechCompRawData (
    ResponseID INT NOT NULL PRIMARY KEY,
    DevType NVARCHAR(100) NOT NULL,
    ExperienceRange NVARCHAR(50) NOT NULL,
    WorkExp INT NOT NULL,
    CompTotal INT NOT NULL
);

-- Use CTE to prepare and insert data
WITH filtered_data AS (
    SELECT 
        ResponseID,
        DevType,
        WorkExp,
        CompTotal,
        CASE 
            WHEN WorkExp BETWEEN 0 AND 2 THEN '1. 0-2 years'
            WHEN WorkExp BETWEEN 3 AND 5 THEN '2. 3-5 years'
            WHEN WorkExp BETWEEN 6 AND 10 THEN '3. 6-10 years'
            WHEN WorkExp BETWEEN 11 AND 15 THEN '4. 11-15 years'
            WHEN WorkExp >= 16 THEN '5. 16+ years'
        END AS ExperienceRange
    FROM breaking_into_tech
    WHERE DevType IS NOT NULL
        AND WorkExp IS NOT NULL
        AND CompTotal IS NOT NULL
        AND CompTotal > 0
        AND WorkExp >= 0
        AND Country = 'United States of America'
        AND Currency = 'USD United States dollar'
)
INSERT INTO TechCompRawData (ResponseID, DevType, ExperienceRange, WorkExp, CompTotal)
SELECT 
    ResponseID,
    DevType,
    ExperienceRange,
    WorkExp,
    CompTotal
FROM filtered_data
WHERE ExperienceRange IS NOT NULL
ORDER BY DevType, ExperienceRange;