# CFPB-Consumer-Complaint-Analysis
This analysis reviewed CFPB consumer complaint data to evaluate operational performance, complaint drivers, and customer resolution effectiveness across financial products and services.
# CFPB Consumer Complaint Analysis (RCA Focused)

## Project Overview

This project analyzes CFPB (Consumer Financial Protection Bureau) consumer complaint data using SQL Server and Power BI to identify operational risks, complaint concentration drivers, and process improvement opportunities across financial products and services.

The project combines:
- SQL data cleaning and transformation
- KPI engineering
- Root Cause Analysis (RCA)
- Pareto Analysis
- Lean operational methodology
- Power BI dashboard development
- Executive reporting and business recommendations

The objective of the project was to transform raw complaint data into a structured analytical solution capable of supporting operational monitoring, complaint prioritization, and data-driven decision-making.

---

# Tools & Technologies

- SQL Server
- Power BI
- DAX
- Git & GitHub
- Root Cause Analysis (RCA)
- Pareto Analysis
- Lean Methodology
- Agile Sprint Workflow

---

# Dataset Overview

The dataset contains consumer complaints related to financial products and services.

Each row represents a single customer complaint submitted regarding a financial institution or service provider.

The dataset includes:

## Temporal Data
- `date_received`
- `date_sent_to_company`

## Categorical Data
- `product`
- `subproduct`
- `issue`
- `subissue`
- `company_name`

## Geographical Data
- `state`

## Operational Data
- `submitted_via`
- `timely_response`
- `company_response_to_consumer`

## Customer Outcome Data
- `consumer_disputed`
- `consumer_consent_provided`

---

# Project Structure

```text
CFPB-Complaint-Analysis
│
├── SQL
├── PowerBI
├── Presentation
├── Documentation
├── Images

---

# SQL Data Preparation & Transformation

A structured data cleaning process was applied to improve data quality and reporting consistency.

Key Cleaning Activities
Data Type Standardization
Converted complaint IDs and ZIP codes into numeric formats
Standardized mixed date formats into SQL DATE format
Date Format Normalization

Resolved inconsistencies between:

```text

UK date format (dd/MM/yyyy)
US date format (MM/dd/yyyy)

Implemented:

CASE
TRY_CONVERT
COALESCE

to correctly parse ambiguous date values.

Text Cleaning
Removed leading/trailing spaces using:
LTRIM
RTRIM
Replaced NULL values with standardized labels such as:
'Unknown'
Categorical Standardization

Normalized inconsistent categories including:

Subproducts
Timely response status
Consumer dispute status
Derived Fields Created
Year Extracted
YEAR(date_received)
Response Time
DATEDIFF(day, date_received, date_sent_to_company)
Data Quality Validation

Implemented flags for invalid timelines where response dates preceded complaint dates.

Analytical SQL View

A cleaned analytical SQL view was created:

CFPB_Consumer_Complaints_2024_clean

Purpose:

centralize transformations
standardize KPI calculations
support Power BI reporting
preserve raw source data integrity
KPI Development
Volume Metrics
Total complaints
Complaints by product
Complaints by issue
Complaints by state
Complaints by year
Performance Metrics
Average response time
On-time response percentage
Customer Outcome Metrics
Closed with explanation %
Closed with non-monetary relief %
Consumer consent provided %
Company compliance response %
Ranking Metrics
Product rankings using DENSE_RANK()
Top 5 complaint issues
Distribution Metrics

Complaint share percentage using SQL window functions:
```text
COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()
SQL KPI Examples
Total Complaints by Product
SELECT 
    [product], 
    COUNT(*) AS total_complaints
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [product]
ORDER BY total_complaints DESC;
On-Time Response Percentage
SELECT 
ROUND(
COUNT(CASE WHEN timely_response_status = 'On Time' THEN 1 END) 
* 100.0 / COUNT(*), 2
) AS on_time_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean];
Complaint Share Percentage
SELECT 
    [product],
    COUNT(*) AS total_complaints,
    CAST(
        COUNT(*) * 100.0 
        / SUM(COUNT(*)) OVER () 
        AS DECIMAL(5,2)
    ) AS complaint_share_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [product];
Power BI Dashboard

A three-page Power BI dashboard was developed using consulting-style design principles.

Page 1 — Executive Summary

Provides high-level operational visibility through:

KPI cards
Complaint trends
Complaint share analysis
Complaints by product
Complaints by issue
Year slicers
KPIs Included
Total Complaints
On-Time %
Average Response Time
Complaint Share %
Page 2 — Root Cause Analysis (RCA)

Focused on identifying operational drivers behind customer complaints.

RCA Visuals
Complaints by issue
Complaints by state
Product × Issue matrix
On-Time % by product
Average response time analysis
Key Finding

Debt Collection represented the dominant complaint category.

Page 3 — Pareto & Lean Analysis

Focused on operational prioritization and process improvement opportunities.

Features
Pareto analysis using DAX
Cumulative complaint percentage calculations
Lean operational analysis
Operational risk concentration analysis
Key Insight

A small number of issue categories generated the majority of complaints.
```text
DAX Measures Developed
Total Complaints
Total Complaints =
COUNTROWS(CFPB_Consumer_Complaints_2024_clean)
Pareto Running Total
Pareto Running Total =
CALCULATE(
    [Total Complaints],
    FILTER(
        ALLSELECTED(CFPB_Consumer_Complaints_2024_clean[issue]),
        [Total Complaints]
            >= CALCULATE(
                [Total Complaints],
                VALUES(CFPB_Consumer_Complaints_2024_clean[issue])
            )
    )
)
Pareto %
Pareto % =
DIVIDE(
    [Pareto Running Total],
    CALCULATE(
        [Total Complaints],
        ALLSELECTED(CFPB_Consumer_Complaints_2024_clean[issue])
    )
)
Key Findings
Debt Collection was identified as the largest complaint driver
Complaint activity was concentrated within a limited number of operational categories
Operational responsiveness remained strong with >99% on-time response rate
Dispute rates highlighted opportunities to improve resolution effectiveness
Geographic complaint concentration identified in Texas and California
Business Recommendations
Operational Recommendations
Strengthen debt ownership verification controls
Improve complaint escalation workflows
Standardize customer communication procedures
Enhance operational monitoring and RCA frameworks
Implement targeted compliance reviews
Methodologies Applied
SQL Data Cleaning & Transformation
KPI Engineering
Root Cause Analysis (RCA)
Pareto Analysis
Lean Operational Analysis
DAX Modeling
Agile Sprint Delivery
Agile Delivery

The project was managed using Agile sprint methodology including:

Sprint planning
Daily stand-ups
Blocker management
KPI prioritization
Iterative dashboard refinement
Final Sprint Deliverables
Power BI Dashboard
Executive Presentation
SQL Scripts
Documentation
Operational Recommendations
Project Outcome

The project successfully delivered a complete end-to-end analytics solution combining:

SQL engineering
Power BI visualization
RCA methodology
Pareto prioritization
Lean operational analysis

The final dashboard and presentation provide actionable insights to support:

operational monitoring
complaint prioritization
customer experience improvement
compliance and risk management
Repository Contents
Folder	Description
SQL	SQL cleaning and KPI scripts
PowerBI	Power BI dashboard file
Presentation	Executive PowerPoint presentation
Documentation	Project summaries and sprint documentation
Images	Dashboard screenshots
Author

Developed as an end-to-end data analytics and operational reporting project focused on customer complaint analysis, RCA methodology, and Lean operational improvement.
