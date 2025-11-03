
/*Creating a new table to record one row for each learnCode option by ResponseID. We will populate it with the Breaking_into_Tech data*/
--Step 1: Create Table
CREATE TABLE LearnCodeResponsesSplit (
	ResponseID INT,
	LearnCodeType VARCHAR(MAX)
);

SELECT *
FROM [Break Into Tech Project].dbo.LearnCodeResponsesSplit;

--Step 2: Populate LearnCodeType with data while using String_Split to split the string into multiple rows using semicolon as the delimeter
--value is the default column name that SQL server gives to each split item. LTRIM and RTRIM remove spaces before and after
INSERT INTO LearnCodeResponsesSplit (ResponseID, LearnCodeType)
SELECT ResponseID, LTRIM(RTRIM(value)) As LearnCodeType
FROM breaking_into_tech
CROSS APPLY STRING_SPLIT(LearnCode, ';');


/*Creating a new column called LearnCategory with Cleaned Categories for the Graph*/
--Step 1: Add new column
ALTER TABLE LearnCodeResponsesSplit
ADD LearnCategory VARCHAR(MAX);


--Step 2: Populate the new column and attribute the new categories using UPDATE SET = CASE
--Set New column = CASE. WHEN old column THEN...
UPDATE [Break Into Tech Project].dbo.LearnCodeResponsesSplit
SET LearnCategory = CASE

WHEN LearnCodeType = 'Online Courses or Certification (includes all media types)'
	THEN 'Online Courses / Certifications'

WHEN LearnCodeType = 'Other online resources (e.g. standard search, forum, online community)'
	THEN 'Standard Search'

WHEN LearnCodeType = 'Stack Overflow or Stack Exchange'
	THEN 'Stack Overflow'

WHEN LearnCodeType = 'Books / Physical media'
	THEN 'Books / E-Books'

WHEN LearnCodeType = 'Videos (not associated with specific online course or certification)'
	THEN 'Videos'

WHEN LearnCodeType = 'Technical documentation (is generated for/by the tool or system)'
	THEN 'Technical documentation'

WHEN LearnCodeType = 'AI CodeGen tools or AI-enabled apps'
	THEN 'AI-Assisted Coding'

WHEN LearnCodeType = 'Colleague or on-the-job training' 
    THEN 'On-Job Training'

WHEN LearnCodeType = 'Blogs or podcasts' 
    THEN 'Blogs or podcasts'

WHEN LearnCodeType = 'Coding Bootcamp' 
    THEN 'Coding Bootcamp'

WHEN LearnCodeType = 'Games or coding challenges' 
    THEN 'Games or Coding challenges'

WHEN LearnCodeType = 'School (i.e., University, College, etc)' 
    THEN 'School/University'

WHEN LearnCodeType = 'Other (please specify):' 
    THEN 'Other'

ELSE 'Other'
END;


