# HumanitarianFunding

## License and Contributions
This project is licensed under the MIT License. Contributions are welcome! See the [Contributions](#contributions) section for details.

## Table of Contents
1. [Introduction](#introduction)
2. [Datasets](#datasets)
3. [SQL Analyses](#sql-analyses)
4. [Features](#features)
5. [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Setup](#setup)
6. [Git Workflow](#git-workflow)
7. [Examples](#examples)
8. [Observations and Insights](#observations-and-insights)
9. [Contributions](#contributions)
10. [License](#license)

## Introduction
Welcome to the Humanitarian Funding Analysis repository! This project focuses on analyzing NGO funding data for Kenya, including funding requirements, allocations, Covid funding, organizations funded, donors, gaps across various sectors and years, etc. By leveraging SQL and visualization tools, users can gain insights into funding trends, gaps, and donor contributions.

## Datasets
The project utilizes publicly available datasets related to humanitarian funding in Kenya. These datasets include:
- **fts_requirements_funding_cluster_ken.csv**: Funding requirements and allocations by cluster.
- **fts_requirements_funding_globalcluster_ken.csv**: Global cluster-level funding data.
- **fts_requirements_funding_covid_ken.csv**: COVID-19-related funding data.
- **fts_incoming_funding_ken.csv**: Incoming funding contributions.
- **fts_requirements_funding_ken.csv**: Allocations per sector in Kenya

## SQL Analyses
This project includes a variety of SQL queries to analyze the funding data. Below are some key analyses performed:
1. **Funding Trends**:
   - Analyze total funding by year.
   - Identify funding gaps across clusters and sectors.
2. **Donor Contributions**:
   - Identify top donors and their contributions.
   - Analyze funding by donor organization types.
3. **COVID-19 Funding**:
   - Calculate the percentage of funding allocated to COVID-19-related efforts.
   - Compare COVID-19 funding to overall funding.
4. **Sectoral Analysis**:
   - Analyze funding distribution across sectors like health, education, and food security.

## Features
- **Joins**: Combine data from multiple tables for comprehensive analysis.
- **Aggregations**: Summarize data by year, sector, and donor.
- **Indexes**: Optimize queries for faster performance.
- **Trend Analysis**: Analyze funding trends over time.
- **Data Cleaning**: Handle missing values and ensure data consistency.

## Getting Started

### Prerequisites
- Microsoft SQL Server Management Studio (SSMS) or a compatible SQL environment.
- Microsoft Power BI or another visualization tool.

### Setup
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/kenobech/HumanitarianFunding.git
   cd HumanitarianFunding
   ```

2. **Set Up the Database**:
   - Import the provided CSV files into your SQL Server database.
   - Use the `HumanitarianFunding.sql` script to create tables, clean data, and perform analyses.

3. **Run the Queries**:
   - Open the `HumanitarianFunding.sql` file in SSMS.
   - Execute the queries step by step to analyze the data.

4. **Explore Visualizations**:
   - Open the `HumanitarianFunding.pbix` file in Microsoft Power BI to interact with the visualizations.
   - Alternatively, view the static visualizations in the `NGO.pdf` file.

## Git Workflow
To collaborate on this project, follow the Git workflow below:

### 1. Clone the Repository
Clone the repository to your local machine:
```bash
git clone https://github.com/kenobech/HumanitarianFunding.git
cd HumanitarianFunding
```

### 2. Create a New Branch
Create a new branch for your feature or bug fix:
```bash
git checkout -b feature/your-feature-name
```

### 3. Make Changes
Edit the files as needed. For example:
- Update the SQL script (`HumanitarianFunding.sql`).
- Add new visualizations or update the Power BI file (`HumanitarianFunding.pbix`).
- Modify the README file.

### 4. Stage Changes
Stage the changes you made:
```bash
git add .
```

### 5. Commit Changes
Commit your changes with a descriptive message:
```bash
git commit -m "Added feature: your-feature-name"
```

### 6. Push Changes
Push your branch to the remote repository:
```bash
git push origin feature/your-feature-name
```

### 7. Create a Pull Request
Go to the GitHub repository and create a pull request for your branch. Provide a detailed description of the changes you made.

### 8. Update Your Local Repository
To keep your local repository up to date with the main branch:
```bash
git checkout main
git pull origin main
```

### 9. Merge Changes
Once your pull request is approved, merge your branch into the main branch:
```bash
git checkout main
git merge feature/your-feature-name
```

### 10. Delete the Branch
After merging, delete the branch to keep the repository clean:
```bash
git branch -d feature/your-feature-name
```

## Examples

### Funding Trends
```sql
SELECT year, SUM(funding) AS total_funding
FROM fts_requirements_funding_cluster_ken
GROUP BY year
ORDER BY year;
```

### Funding Gap by Cluster
```sql
SELECT cluster, SUM(requirements - funding) AS funding_gap
FROM fts_requirements_funding_cluster_ken
GROUP BY cluster
ORDER BY funding_gap DESC;
```

### COVID-19 Funding Percentage
```sql
SELECT name, (covidFunding * 100.0 / funding) AS covid_funding_percentage
FROM fts_requirements_funding_covid_ken
WHERE funding > 0
ORDER BY covid_funding_percentage DESC;
```

### Top Donors by Contribution
```sql
SELECT srcOrganization, SUM(amountUSD) AS total_contribution
FROM fts_incoming_funding_ken
GROUP BY srcOrganization
ORDER BY total_contribution DESC;
```

## Observations and Insights
Based on the SQL analyses and visualizations, the following key insights were observed:

1. **Yearly Funding Trends**:
   - The year **2024** had the highest NGO funding allocation, totaling **$30,385,946**.
   - The year **2020** had the lowest allocation, with only **$2,669,195**.
   - No allocations were recorded for the years **2018** and **2019**.

2. **Top Recipients**:
   - The **United Nations High Commissioner for Refugees** received the highest donation, amounting to **$21,772,670**.
   - **Multilateral organizations** received the most funding overall.

3. **Top Donors**:
   - The majority of donations came from **Belgium** and **Germany**, making them the highest contributors.

4. **Sectoral Funding**:
   - A significant portion of the funding was allocated to address **hunger crises** and **food insecurity**.
   - **Agriculture** was one of the most highly funded sectors.
   - The **Kenya Drought Appeal** also received substantial funding.

5. **COVID-19 Funding**:
   - The total COVID-19-related funding stood at **$66 million**, with most of the funding occurring in **2020** during the pandemic.

## Conclusion
The analysis highlights the critical role of international donors and NGOs in addressing humanitarian crises in Kenya. The data shows that funding priorities have been directed toward food security, agriculture, and drought response, with significant contributions from Belgium and Germany. The COVID-19 pandemic also triggered a notable increase in funding in 2020, emphasizing the global response to health emergencies. These insights can guide future funding strategies and resource allocation to maximize impact in addressing humanitarian needs.

## Contributions
Contributions to the Humanitarian Funding Analysis project are welcome! To contribute:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
