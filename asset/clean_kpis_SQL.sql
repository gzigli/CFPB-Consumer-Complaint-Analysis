USE Banking_Data;
GO

-- KPI: Total complaints by product
SELECT 
    [product], 
    COUNT(*) AS total_complaints
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [product]
ORDER BY total_complaints DESC;

-- KPI: Total complaints by issue
SELECT 
    [issue], 
    COUNT(*) AS total_complaints
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [issue]
ORDER BY total_complaints DESC;

-- KPI: Total complaints by state
SELECT 
    [state], 
    COUNT(*) AS total_complaints
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [state]
ORDER BY total_complaints DESC;

-- KPI: Total complaints by year received
SELECT 
    [year_received], 
    COUNT(*) AS total_complaints
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [year_received]
ORDER BY [year_received] DESC;

-- KPI: Average response time
SELECT 
    AVG([time_response]) AS avg_response_time
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean];

-- KPI: % On Time
SELECT 
     ROUND( COUNT(CASE WHEN timely_response_status = 'On Time' THEN 1 END) * 100.0 / COUNT(*),2)  AS on_time_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean];

-- KPI: % On Time by year
SELECT 
    [year_received],
     ROUND( COUNT(CASE WHEN timely_response_status = 'On Time' THEN 1 END) * 100.0 / COUNT(*),2)  AS on_time_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [year_received]
ORDER BY [year_received] DESC;

-- KPI: % On Time by product
SELECT 
    [product],
     ROUND( COUNT(CASE WHEN timely_response_status = 'On Time' THEN 1 END) * 100.0 / COUNT(*),2)  AS on_time_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [product]
ORDER BY on_time_percentage DESC;

-- KPI: % On Time by issue
SELECT 
    [issue],
    CAST(  COUNT(CASE WHEN timely_response_status = 'On Time' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2))  AS on_time_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [issue]
ORDER BY on_time_percentage DESC;

-- KPI: % Closed with explanation
SELECT 
    CAST(  COUNT(CASE WHEN company_response_to_consumer = 'Closed with explanation' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2))  AS explanation_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean];

-- KPI: % Closed with explanation by year
SELECT 
    [year_received],
     CAST( COUNT(CASE WHEN company_response_to_consumer = 'Closed with explanation' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2))  AS explanation_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [year_received]
ORDER BY [year_received] DESC;

-- KPI: % Closed with explanation by issue
SELECT 
    [issue],
     CAST( COUNT(CASE WHEN company_response_to_consumer = 'Closed with explanation' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2))  AS explanation_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [issue]
ORDER BY explanation_percentage DESC;

-- KPI: % Closed with explanation by product
SELECT 
    [product],
     CAST( COUNT(CASE WHEN company_response_to_consumer = 'Closed with explanation' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2))  AS explanation_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [product]
ORDER BY explanation_percentage DESC;

-- KPI: % Closed or explained
SELECT 
     CAST( COUNT(CASE WHEN company_response_to_consumer IN ('Closed with non-monetary relief', 'Closed') THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS closed_or_explained_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean];

-- KPI: % Consent provided
SELECT 
     CAST( COUNT(CASE WHEN consumer_consent_provided = 'Consent provided' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2))  AS consent_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean];

-- KPI: % Company says it followed contract or law
SELECT 
    CAST(  COUNT(CASE WHEN company_public_response = 'Company believes it acted appropriately as authorized by contract or law' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS law_followed_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean];

-- Ranking: Products based on complaints
WITH ProductCounts AS (
    SELECT 
        [product], 
         COUNT(*) AS total_complaints
    FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
    GROUP BY [product]
)
SELECT 
    [product],
    total_complaints,
    DENSE_RANK() OVER (ORDER BY total_complaints DESC) AS rank_product
FROM ProductCounts;

-- Ranking: Top 5 issues based on complaints
WITH IssueCounts AS (
    SELECT 
        [issue], 
        COUNT(*) AS total_complaints
    FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
    GROUP BY [issue]
),
RankedIssues AS (
    SELECT 
        [issue],
        total_complaints,
        DENSE_RANK() OVER (ORDER BY total_complaints DESC) AS rank_issue
    FROM IssueCounts
)
SELECT 
    [issue],
    total_complaints,
    rank_issue
FROM RankedIssues
WHERE rank_issue <= 5;

--Dispute Rate

SELECT CAST(COUNT(CASE WHEN [consumer_disputed] IN ('TRUE') THEN 1 END) *100.0/ COUNT(*) AS DECIMAL(5,2))  dispute_rate
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
ORDER BY dispute_rate DESC;
--Average response time by product

SELECT 
    [product],
    CAST(AVG([time_response] * 1.0 ) AS DECIMAL(5,2)) AS avg_response_time
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [product]
ORDER BY avg_response_time DESC;

--On-time vs disputed

SELECT 
    [timely_response_status],
    [consumer_disputed_status],
    COUNT(*) AS total_cases
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [timely_response_status], [consumer_disputed_status]
ORDER BY total_cases DESC;

--Top 5 states by complaints
SELECT TOP 5
    [state],
    COUNT(*) AS total_complaints
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [state]
ORDER BY total_complaints DESC;

--Complaint share by product

SELECT 
    [product],
    COUNT(*) AS total_complaints,
   CAST( COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS complaint_share_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [product];
