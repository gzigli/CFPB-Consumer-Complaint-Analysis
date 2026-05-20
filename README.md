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

## Dataset Includes

### Temporal Data
- `date_received`
- `date_sent_to_company`

### Categorical Data
- `product`
- `subproduct`
- `issue`
- `subissue`
- `company_name`

### Geographical Data
- `state`

### Operational Data
- `submitted_via`
- `timely_response`
- `company_response_to_consumer`

### Customer Outcome Data
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
```

---

# SQL Data Preparation & Transformation

A structured data cleaning process was applied to improve data quality and reporting consistency.

## Key Cleaning Activities

### Data Type Standardization

- Converted complaint IDs and ZIP codes into numeric formats
- Standardized mixed date formats into SQL DATE format

### Date Format Normalization

Resolved inconsistencies between:

- UK date format (`dd/MM/yyyy`)
- US date format (`MM/dd/yyyy`)

Implemented:

- `CASE`
- `TRY_CONVERT`
- `COALESCE`

to correctly parse ambiguous date values.

### Text Cleaning

- Removed leading/trailing spaces using:
  - `LTRIM`
  - `RTRIM`
- Replaced NULL values with standardized labels such as:
  - `'Unknown'`

### Categorical Standardization

Normalized inconsistent categories including:

- Subproducts
- Timely response status
- Consumer dispute status

---

# Derived Fields Created

## Year Extracted

```sql
YEAR(date_received)
```

## Response Time

```sql
DATEDIFF(day, date_received, date_sent_to_company)
```

## Data Quality Validation

Implemented flags for invalid timelines where response dates preceded complaint dates.

---

# Analytical SQL View

A cleaned analytical SQL view was created:

```text
CFPB_Consumer_Complaints_2024_clean
```

## Purpose

- Centralize transformations
- Standardize KPI calculations
- Support Power BI reporting
- Preserve raw source data integrity

---

# KPI Development

## Volume Metrics

- Total complaints
- Complaints by product
- Complaints by issue
- Complaints by state
- Complaints by year

## Performance Metrics

- Average response time
- On-time response percentage

## Customer Outcome Metrics

- Closed with explanation %
- Closed with non-monetary relief %
- Consumer consent provided %
- Company compliance response %

## Ranking Metrics

- Product rankings using `DENSE_RANK()`
- Top 5 complaint issues

## Distribution Metrics

Complaint share percentage using SQL window functions:

```sql
COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()
```

---

# SQL KPI Examples

## Total Complaints by Product

```sql
SELECT 
    [product], 
    COUNT(*) AS total_complaints
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean]
GROUP BY [product]
ORDER BY total_complaints DESC;
```

## On-Time Response Percentage

```sql
SELECT 
ROUND(
COUNT(CASE WHEN timely_response_status = 'On Time' THEN 1 END) 
* 100.0 / COUNT(*), 2
) AS on_time_percentage
FROM [dbo].[CFPB_Consumer_Complaints_2024_clean];
```

## Complaint Share Percentage

```sql
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
```

---

# Power BI Dashboard

A three-page Power BI dashboard was developed using consulting-style design principles.

---

# Page 1 — Executive Summary

Provides high-level operational visibility through:

- KPI cards
- Complaint trends
- Complaint share analysis
- Complaints by product
- Complaints by issue
- Year slicers

## KPIs Included

- Total Complaints
- On-Time %
- Average Response Time
- Complaint Share %

---

# Page 2 — Root Cause Analysis (RCA)

Focused on identifying operational drivers behind customer complaints.

## RCA Visuals

- Complaints by issue
- Complaints by state
- Product × Issue matrix
- On-Time % by product
- Average response time analysis

## Key Finding

Debt Collection represented the dominant complaint category.

---

# Page 3 — Pareto & Lean Analysis

Focused on operational prioritization and process improvement opportunities.

## Features

- Pareto analysis using DAX
- Cumulative complaint percentage calculations
- Lean operational analysis
- Operational risk concentration analysis

## Key Insight

A small number of issue categories generated the majority of complaints.

---

# DAX Measures Developed

## Total Complaints

```DAX
Total Complaints =
COUNTROWS(CFPB_Consumer_Complaints_2024_clean)
```

## Pareto Running Total

```DAX
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
```

## Pareto %

```DAX
Pareto % =
DIVIDE(
    [Pareto Running Total],
    CALCULATE(
        [Total

```


---

# Executive Findings & Recommendations Presentation

This section summarizes the key operational findings identified through KPI analysis, Root Cause Analysis (RCA), Pareto analysis, and Lean methodology. The objective of the presentation was to translate analytical findings into actionable business recommendations and operational improvement opportunities.

---

# Key Findings

## Operational Performance Findings

| KPI | Result |
|---|---|
| Total Complaints | 127 |
| On-Time Response Rate | 99.21% |
| Disputed Resolutions | 15% |
| Closed with Explanation | 29% |
| Company Followed Law | 51.97% |

### Key Observation

The organization demonstrates strong operational responsiveness with a high on-time response rate; however, dispute levels and complaint concentration indicate opportunities to improve resolution effectiveness, customer communication, and operational governance.

---

# Complaint Concentration Findings

## Primary Complaint Drivers

The analysis identified that the majority of complaints originated from:

- Debt Collection activities
- Continued attempts to collect debts not owned by customers
- Communication tactics during debt collection interactions

## Geographic Concentration

The highest complaint volumes originated from:

- Texas
- California

### Operational Insight

The concentration of complaints within a limited number of operational categories suggests process inefficiencies and potential weaknesses in debt validation and communication procedures.

---

# Trend Analysis Findings

## Complaint Trend Overview

| Year | Complaints |
|---|---|
| 2015 | 45 |
| 2018 | 6 |
| 2020 | 12 |

### Trend Observation

Although complaint volumes increased slightly between 2018 and 2020, the overall complaint levels remained significantly lower than 2015 levels, indicating operational improvement over time.

However, recurring complaint themes suggest unresolved systemic process issues within debt collection operations.

---

# Root Cause Analysis (RCA)

## Key Operational Risks Identified

### 1. Debt Ownership Validation Issues

Complaints indicate repeated attempts to collect debts from individuals who do not own the debt.

### 2. Communication Process Weaknesses

Customers reported dissatisfaction with communication tactics and escalation handling.

### 3. Resolution Effectiveness Gaps

A 15% dispute rate suggests that some complaint resolutions did not fully resolve customer concerns.

### 4. Compliance Consistency Risks

Only 51.97% of responses explicitly indicated compliance with contractual or legal obligations.

---

# Pareto Analysis Findings

Pareto analysis demonstrated that a small number of issue categories generated the majority of complaint activity.

## Lean Observation

This confirms operational concentration risk and indicates that targeted improvements in debt collection workflows could significantly reduce total complaint volumes.

---

# Business Recommendations

## 1. Strengthen Debt Validation Controls

### Recommendation
Implement mandatory debt ownership verification procedures before collection activity begins.

### Expected Outcome
- Reduced incorrect debt collection attempts
- Lower complaint volumes
- Reduced operational risk

---

## 2. Improve Customer Communication Practices

### Recommendation
Standardize compliant communication procedures and escalation handling processes.

### Expected Outcome
- Improved customer experience
- Reduced dispute rates
- Increased complaint resolution effectiveness

---

## 3. Enhance Complaint Resolution Frameworks

### Recommendation
Introduce standardized RCA tagging and escalation prioritization workflows.

### Expected Outcome
- Faster issue resolution
- Better operational visibility
- Improved trend identification

---

## 4. Expand Compliance Monitoring

### Recommendation
Implement additional operational audits and compliance monitoring for high-risk complaint categories.

### Expected Outcome
- Improved regulatory alignment
- Reduced compliance exposure
- Improved operational governance

---

## 5. Geographic Risk Monitoring

### Recommendation
Perform targeted reviews of complaint drivers within Texas and California operations.

### Expected Outcome
- Improved regional operational controls
- Better complaint trend monitoring
- Reduced geographic concentration risk

---

# Expected Business Outcomes

Implementation of the recommendations is expected to support:

- Reduced complaint concentration
- Lower dispute rates
- Improved customer satisfaction
- Improved complaint resolution effectiveness
- Stronger compliance alignment
- Reduced operational and reputational risk

---

# Final Conclusion

The project successfully delivered an end-to-end analytics solution combining:

- SQL data engineering
- KPI development
- Power BI dashboarding
- Root Cause Analysis (RCA)
- Pareto prioritization
- Lean operational analysis

The final dashboard and presentation provide actionable operational insights capable of supporting process optimization, compliance monitoring, and customer experience improvement initiatives.
