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
This dashboard explores **49,000+ Stack Overflow Developer Survey responses** to uncover trends in AI adoption, compensation, and learning pathways — insights that are guiding my own transition into Tech.
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

##Technical Highlights (SQL + Power BI)

1. Salary Analysis by role (bar chart)
<img width="1087" height="328" alt="image" src="https://github.com/user-attachments/assets/5b8eceeb-8171-4d19-a8e7-c1c4968fb8d5" />
<br>
**Objective:** To show how median compensation varies by developer role in the United States.
<br>
| Concepts | Purpose |
|-----------|---------|
| **Subquery + window function** | Calculates median salary per DevType using `PERCENTILE_CONT` (SQL Server has no `MEDIAN()` function) |
| **Aggregation in outer query** | Adds average years of experience + number of respondents |
| **Sample size filter** | `HAVING COUNT(*) >= 10` prevents misleading medians from tiny groups |
| **Pre-aggregated table output** | Power BI only visualizes the result — no DAX median needed |

**SQL example (core logic)**

```sql
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CompTotal)
    OVER (PARTITION BY DevType) AS MedianSalary

## Data Source
**[2025 Stack Overflow Developer Survey](https://survey.stackoverflow.co/)** | Licensed under [ODbL](http://opendatacommons.org/licenses/odbl/1.0/) <br/>
*All analysis and insights are my own. Stack Overflow is not affiliated with this project.*
