# Breaking into Tech: 2025 Stack Overflow Developer Survey Dashboard
## Preview
<table>
  <tr>
    <td width="50%">
      <b>Learning Pathways</b><br/>
      <img width="100%" alt="Overview" src="https://github.com/user-attachments/assets/8ad56a73-5d51-4ac8-95ac-5da19db85735" />
    </td>
    <td width="50%">
      <b>The Rise of AI</b><br/>
      <img width="100%" alt="AI Dashboard" src="https://github.com/user-attachments/assets/b5e20958-ab28-42ca-ae50-f0fb39e1d007" />
    </td>
  </tr>
  <tr>
    <td colspan="2" align="center">
      <b>TechComp Trends</b><br/>
      <img width="60%" alt="Compensation Dashboard" src="https://github.com/user-attachments/assets/1719dd6d-241c-47ae-88dc-3a52c46e9431" />
    </td>
  </tr>
</table>
<hr style="border: 2px solid #0969DA;">

## Project Overview
This dashboard is part of my **Breaking Into Tech** series. After almost a decade in Finance, I'm analyzing real developer data to understand the Technology industry. 
This dashboard explores **49,000+ 2025 Stack Overflow Developer Survey responses** to uncover trends in AI adoption, compensation, and learning pathways — insights that are guiding my own transition into Tech.
<hr style="border: 2px solid #0969DA;">

## View Live Dashboard
[![Power BI](https://img.shields.io/badge/Power_BI-View_Live_Dashboard-00D084?style=for-the-badge&logo=powerbi&logoColor=white)](https://app.powerbi.com/view?r=eyJrIjoiOWRkNDU4OTktN2E2NS00NmU0LWE2MzQtZTk3N2Y1MjQ2YjAyIiwidCI6IjJhYmQ1YTUwLThlZjctNGRjZi04Yzc5LWE0ZWFlNTJlZGIyMSJ9&pageName=b2b3890d4d5c5f56d666)

<hr style="border: 2px solid #0969DA;">

## Key Insights

**How Developers Learn<br>**
⮕**Technical documentation leads at 68% usage** across both new learners and professionals, making it the most reliable learning resource<br/>
⮕**39% of Gen Z developers list coding challenges as their preferred format, yet only 15% used them in the past year to learn.** This 24-percentage-point gap between preference and usage signals an underserved market opportunity: platforms that can deliver engaging, high-quality coding challenges could capture significant user growth by meeting this unmet demand, particularly among the next generation of developers.
<br/>
<br/>
**The AI Paradox<br>**
⮕**78% of developers use AI tools, yet 46% distrust their accuracy.** The disconnect between high usage and low trust suggests developers have embraced AI as a productivity tool, using it for boilerplate code, documentation lookup, and prototyping while still applying critical judgment to outputs<br>
⮕**64% believe AI is not a threat to their current jobs**, reinforcing that AI is viewed as an assistant rather than a replacement technology.<br>
⮞**The takeaway: AI literacy is expected, but human judgment remains irreplaceable**
<br/>
<br/>
**The Compensation Curve<br>**
⮕**Mid-career developers (6-10 years) see the steepest salary growth**: a 45% jump from $100K to $145K. After crossing the 10-year mark, growth slows substantially to just 17% over the next decade, reaching $170K at 16+ years
<br/>
<hr style="border: 2px solid #0969DA;">

## Technical Highlights (SQL + Power BI)

> **📊 Data Architecture:**  
> This dashboard uses a direct SQL Server connection in Power BI, keeping data current and eliminating stale insights common with static CSV imports.

**1. Salary Analysis by Role**

**Visualization:** Bar chart showing median compensation by developer role (U.S. only)

| Concepts | Purpose |
|------------|-----------------|
| **Window function** | Uses `PERCENTILE_CONT(0.5) over (PARTITION BY DevType)` to calculate median salary while keeping all rows available for additional filtering |
| **Subquery** | Separates median salary calculation from final aggregation to improve readability and reusability |
| **Role-level aggregation** | Summarizes multiple salary records into a single row per DevType for graphing in Power BI |
| **Sample size filter** | Filters out roles with fewer than 10 respondents using `HAVING COUNT(*) >= 10` to avoid misleading medians |

```sql
-- Median salary by role (dataset for Power BI bar chart)
SELECT 
    DevType,
    CompTotal,
    PERCENTILE_CONT(0.5)                    -- Calculate 50th percentile (median)
    WITHIN GROUP (ORDER BY CompTotal) 
    OVER (PARTITION BY DevType)             -- Group by role without collapsing rows
    AS MedianSalary
FROM breaking_into_tech
WHERE Country = 'United States of America'  -- Filter for US salaries only
  AND Currency = 'USD United States dollar'
  AND CompTotal IS NOT NULL
GROUP BY DevType
HAVING COUNT(*) >= 10;                      -- Remove roles with <10 respondents
```

**2. Salary Progression by Experience**

**Visualization:** Interactive line chart showing salary progression by experience level for selected developer role

| Concepts | Purpose |
|----------|---------|
| **Common Table Expression (CTE)** | Creates a temporary named query that cleans data before inserting into the final table, making the query easier to read and debug |
| **CASE expression** | Creates experience bands (0-2 years, 3-5 years, etc.) with numeric prefixes for proper sorting when graphing |
| **Data quality filtering** | Removes invalid records (`IS NOT NULL`, `CompTotal > 0`) in SQL to improve performance and ensure consistency across visuals |
| **INSERT INTO SELECT** | Populates reporting table with transformed data, moving heavy processing to SQL rather than Power BI, improving dashboard load times |

```sql
-- CTE to filter and categorize raw survey data
WITH filtered_data AS (
    SELECT 
        ResponseID,
        DevType,
        WorkExp,
        CompTotal,
        CASE 
            WHEN WorkExp BETWEEN 0 AND 2 THEN '1. 0-2 years'      -- Entry level
            WHEN WorkExp BETWEEN 3 AND 5 THEN '2. 3-5 years'      -- Early career
            WHEN WorkExp BETWEEN 6 AND 10 THEN '3. 6-10 years'    -- Mid career
            WHEN WorkExp BETWEEN 11 AND 15 THEN '4. 11-15 years'  -- Senior
            WHEN WorkExp >= 16 THEN '5. 16+ years'                -- Expert level
        END AS ExperienceRange
    FROM breaking_into_tech
    WHERE DevType IS NOT NULL                                      -- Remove missing values
      AND CompTotal > 0                                            -- Filter out invalid salaries
      AND Country = 'United States of America'
      AND Currency = 'USD United States dollar'
);
```

**3. Learning Methods Analysis**

**Visualization:** Bar chart showing distribution of learning approaches
> **⚠️ Data Challenge:**  
> The `LearnCode` field stored multiple learning methods in a single delimited string (e.g., "Online courses; Bootcamp; Books") ➜ not suitable for filtering, grouping, or establishing relationships in Power BI.<br>
> **✅ Solution:** Split delimited strings into separate rows using `STRING_SPLIT` with `CROSS APPLY`.<br>
> **🎯 Result** Each learning method is now normalized to one row per response, enabling % calculations and slicer analysis in Power BI.

| Concepts | Purpose |
|----------|---------|
| Data normalization | Splits multi-value field into separate rows to create proper relational structure for analysis |
| STRING_SPLIT with CROSS APPLY | Transforms delimited string (e.g., "Online courses; Bootcamp; Books") into individual rows, one per learning method |
| LTRIM and RTRIM | Removes leading and trailing whitespace from parsed values to ensure data consistency |
| UPDATE with CASE | Standardizes category names post-insert for user-friendly labels in Power BI |
| Composite key | Uses `ResponseID` + `LearnCodeType` to establish one-to-many relationship with parent table |

```sql
-- Split multi-select field into normalized rows
INSERT INTO LearnCodeResponsesSplit (ResponseID, LearnCodeType)
SELECT 
    ResponseID,
    LTRIM(RTRIM(value)) AS LearnCodeType           -- Remove whitespace from parsed values
FROM breaking_into_tech
CROSS APPLY STRING_SPLIT(LearnCode, ';');          -- Split delimited string into rows

-- Standardized category names using UPDATE with CASE (LearnCodeType → LearnCategory)
```

**DAX Measure for Bar Chart Visualization:**
```dax
% of Respondents Using Learning Method = 
DIVIDE(
    DISTINCTCOUNT(LearnCodeResponsesSplit[ResponseID]),     -- Count unique respondents, important since after normalization we have repeated ResponseIDs
    CALCULATE(
        DISTINCTCOUNT(LearnCodeResponsesSplit[ResponseID]), -- Total (excluding blanks)
        NOT ISBLANK(LearnCodeResponsesSplit[LearnCategory]) -- LearnCategory created via UPDATE/CASE (not shown)
))
```

<hr style="border: 2px solid #0969DA;">

## Analytical Approach & Design

**Exploratory Data Analysis**
- Built exploratory bar charts segmented by demographics and behavior (new vs. experienced learners) to identify patterns
- Identified key insight: 33% of new learners use AI-assisted tools → featured in a custom KPI card
- Validated key findings against the official 2025 Stack Overflow Developer Survey report before finalizing dashboard metrics

**Data Storytelling & Layout**
- Designed three-page narrative flow: *Learning Pathways* → *The Rise of AI* → *TechComp Trends*
- Structured each page to answer a specific question relevant to career changers entering tech

**Custom Visualizations**
- Extended beyond usual Power BI visuals using HTML/CSS for gradient-styled KPI cards
- Created color-coded trust scale legend (red = low trust → green = high trust) for intuitive interpretation

<hr style="border: 2px solid #0969DA;">

## Repository Contents

**Power BI Dashboard:**
- `Breaking into Tech Project.pbix` - Interactive dashboard with data model and DAX measures

**SQL Scripts:**
- `TechCompGraphAvgExp.sql` - Median salary calculation by developer role
- `TechCompGraphSalaryProgression.sql` - Salary progression across experience levels
- `LearnCodeResponsesSplit.sql` - Learning methods data normalization

<hr style="border: 2px solid #0969DA;">

## Data Source
**[2025 Stack Overflow Developer Survey](https://survey.stackoverflow.co/)** | Licensed under [ODbL](http://opendatacommons.org/licenses/odbl/1.0/) <br/>
*All analysis and insights are my own. Stack Overflow is not affiliated with this project.*
