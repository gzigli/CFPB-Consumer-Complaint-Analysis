USE Banking_Data
GO

CREATE VIEW CFPB_Consumer_Complaints_2024_clean AS

WITH Clean_date AS (SELECT

LTRIM(RTRIM(TRY_CONVERT(int,[complaint_id]))) as complaint_id,
LTRIM(RTRIM(FORMAT(CAST([date_received] as date), 'dd/MM/yyyy'))) as date_received_uk,
LTRIM(RTRIM(FORMAT(CAST([date_sent_to_company] as date), 'dd/MM/yyyy'))) as date_sent_to_company_uk,
LTRIM(RTRIM([product])) as product,
ISNULL(LTRIM(RTRIM([issue])),'Unknown') as issue,
ISNULL(LTRIM(RTRIM([subissue])),'Unknown') as subissue,
ISNULL(LTRIM(RTRIM(TRY_CONVERT(int,[zip_code]))),0) as zip_code,
ISNULL(LTRIM(RTRIM([company_public_response])),'Unknown') as company_public_response,
ISNULL(LTRIM(RTRIM([company_name])),'Unknown') as company_name,
ISNULL(LTRIM(RTRIM([state])),'Unknown') as state,
ISNULL(LTRIM(RTRIM([company_response_to_consumer])),'Unknown') as company_response_to_consumer,
ISNULL(LTRIM(RTRIM([tags])),'Unknown') as tags,
ISNULL(LTRIM(RTRIM([consumer_consent_provided])),'Unknown') as consumer_consent_provided,
ISNULL(LTRIM(RTRIM([consumer_disputed])),'Unknown') as consumer_disputed,
ISNULL(LTRIM(RTRIM([submitted_via])),'Unknown') as submitted_via,

CASE

    WHEN ISNULL(LTRIM(RTRIM([subproduct])),'Unknown') IN ('I do not know') OR  ISNULL(LTRIM(RTRIM([subproduct])),'Unknown') IS NULL THEN 'Unknown'
    WHEN ISNULL(LTRIM(RTRIM([subproduct])),'Unknown') IN ('Other (i.e. phone, health club, etc.)','Other debt') THEN 'Debt'
    ELSE ISNULL(LTRIM(RTRIM([subproduct])),'Unknown')
    
    END AS subproduct,

CASE

    WHEN ISNULL(LTRIM(RTRIM([timely_response])),'Unknown') IN ('TRUE')  THEN 'On Time'
    WHEN ISNULL(LTRIM(RTRIM([timely_response])),'Unknown') IN ('FALSE') THEN 'Late'
    ELSE ISNULL(LTRIM(RTRIM([timely_response])),'Unknown')
    
    END AS timely_response_status,

CASE

    WHEN ISNULL(LTRIM(RTRIM([consumer_disputed])),'Unknown') IN ('TRUE')  THEN 'Desputed'
    WHEN ISNULL(LTRIM(RTRIM([consumer_disputed])),'Unknown') IN ('FALSE') THEN 'Accepted'
    ELSE ISNULL(LTRIM(RTRIM([consumer_disputed])),'Unknown')
    
    END AS consumer_disputed_status,

    -

--fix dates UK/US

CASE  
     WHEN TRY_CONVERT(int,LEFT([date_received],2)) > 12 THEN TRY_CONVERT(date,[date_received],103) 
     WHEN TRY_CONVERT(int,SUBSTRING([date_received],4,2)) > 12 THEN TRY_CONVERT(date,[date_received],101)
     ELSE COALESCE (TRY_CONVERT(date,[date_received],101) ,TRY_CONVERT(date,[date_received],103)) END AS date_received,


CASE  
     WHEN TRY_CONVERT(int,LEFT([date_sent_to_company],2)) > 12 THEN TRY_CONVERT(date,[date_sent_to_company],103) 
     WHEN TRY_CONVERT(int,SUBSTRING([date_sent_to_company],4,2)) > 12 THEN TRY_CONVERT(date,[date_sent_to_company],101)
     ELSE COALESCE (TRY_CONVERT(date,[date_sent_to_company],101) ,TRY_CONVERT(date,[date_sent_to_company],103)) END AS date_sent_to_company,

     DATEDIFF(day,date_received,date_sent_to_company) as time_response

     FROM [dbo].[CFPB_Consumer_Complaints_2024])

     SELECT 

     --clean spaces and provide the correct data formatting for each column

complaint_id,
date_received_uk,
date_sent_to_company_uk,
product,
issue,
subissue,
zip_code,
company_public_response,
company_name,
state,
company_response_to_consumer,
tags,
consumer_consent_provided,
consumer_disputed,
submitted_via,
consumer_disputed_status,
timely_response_status,
subproduct,



--year
YEAR(date_received) as year_received,

time_response
    
 

FROM Clean_date

WHERE time_response > 0;
