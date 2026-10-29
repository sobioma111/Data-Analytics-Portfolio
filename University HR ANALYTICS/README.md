# University HR Analytics
## Project Overview
### Dashboard Preview

![University HR Analytics Dashboard](Dashboard%20Images/University%20HR%20analytics%20%282%29.png)
An HR analytics project exploring staff information, qualifications, salary totals, and recorded publications using Power Query and Power BI.

## Key Performance Indicators
- **Total Staff:** 2,000
- **Number of Departments:** 16
- **Total Salary:** 685.24M (unit not specified in the source data)
- **Recorded Publications:** 69,739

## Tools Used
- Microsoft Excel
- Power Query
- Power BI
## Data Cleaning
The dataset was prepared using Power Query in Power BI. The following steps were performed:

- Promoted Headers: Used the first row as column headers.
- Changed Data Types: Corrected column data types for proper analysis.
- Trimmed Text: Removed unnecessary spaces from text fields.
- Cleaned Text: Removed unwanted non-printing characters from text fields.
- Standardized Text: Improved consistency in text values.
- Replaced Errors: Handled errors encountered during data preparation.
- Handled Missing Publication Values: Replaced missing values in the Number of Publications column with 0.
- Handled Missing Specialization Values: Replaced missing Area of Specialization values with "unknown".
 ## Data quality note:
   The dataset contained 880 missing values in the Number of Publications column. Replacing these with zero assumes that missing publication records represent no recorded publications; this assumption should be considered when interpreting the results.


## Limitations

The dataset was supplied for training and may be simulated. The salary currency and period were not specified. Replacing missing publication values with zero may affect interpretation.

## Project Deliverables
- [Dashboard Preview](Dashboard%20Images/University%20HR%20analytics%20%282%29.png)
- [Power BI Desktop File (.pbix)](Power%20BI%20Files/UNIVERSITY%20HR%20ANALYTICS.OBIOMA.pbix)

* [Project Report (PDF)](Project%20Report/University_HR_Analytics_Project_Report.pdf)

* [Project Report (Word)](Project%20Report/University_HR_Analytics_Project_Report.docx)

* [Project Presentation](Presentations/University_HR_Analytics_Presentation.pptx)


