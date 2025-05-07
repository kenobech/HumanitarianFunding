
--Select the Database to Use
USE [Humanitarian Funding Kenya];


--Show all the tables in the Database
SELECT *
FROM sys.tables;

--Inspect the Table Structure
SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_incoming_funding_ken';

SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_requirements_funding_ken';

SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_requirements_funding_covid_ken';

SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_requirements_funding_cluster_ken';

SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_requirements_funding_globalcluster_ken';

--Check for Null Values in all the tables and updating them
--Table 1: fts_incoming_funding_ken
SELECT * 
FROM fts_incoming_funding_ken
WHERE 
    date IS NULL OR 
    budgetYear IS NULL OR 
    description IS NULL OR
    amountUSD IS NULL OR
    srcOrganization IS NULL OR
    srcOrganizationTypes IS NULL OR
    srcLocations IS NULL OR
    srcUsageYearStart IS NULL OR
    srcUsageYearEnd IS NULL OR
    destOrganization IS NULL OR
    destOrganizationTypes IS NULL OR
    destGlobalClusters IS NULL OR
    destLocations IS NULL OR
    id IS NULL;

-- Updating the Null Values
-- budgetYear Column
UPDATE fts_incoming_funding_ken
SET budgetYear = 
    CASE 
        WHEN MONTH(date) >= 7 THEN YEAR(date) 
        ELSE YEAR(date) - 1 
    END
WHERE budgetYear IS NULL AND date IS NOT NULL;

--srcLocations Column
UPDATE fts_incoming_funding_ken
SET srcLocations = CASE
WHEN srcOrganization = 'European Commission' AND srcLocations IS NULL THEN 'BELG'
WHEN srcOrganization = 'European Commission''s Humanitarian Aid and Civil Protection Department' AND srcLocations IS NULL THEN 'BELG'
WHEN srcOrganization = 'Save the Children' AND srcLocations IS NULL THEN 'USA'
WHEN srcOrganization = 'Taiwan International Cooperation and Development Fund' AND srcLocations IS NULL THEN 'CHN'
ELSE srcLocations
END
WHERE srcLocations IS NULL;

--destOrganization Column
UPDATE fts_incoming_funding_ken
SET destOrganization = CASE
WHEN srcOrganization = 'United States of America, Government of' AND destOrganization IS NULL THEN 'Governments'
ELSE destOrganization
END
WHERE destOrganization IS NULL;

--destOrganizationTypes Column
UPDATE fts_incoming_funding_ken
SET destOrganizationTypes = CASE
WHEN destOrganization = 'Governments' AND destOrganizationTypes IS NULL THEN 'Governments'
ELSE destOrganizationTypes
END
WHERE destOrganizationTypes IS NULL;

--destGlobalClusters Column
UPDATE fts_incoming_funding_ken
SET destGlobalClusters = CASE
WHEN destOrganization = 'United Nations Children''s Fund' AND destGlobalClusters IS NULL THEN 'Protection'
WHEN destOrganization = 'Danish Refugee Council' AND destGlobalClusters IS NULL THEN 'Multi-sector'
WHEN destOrganization = 'International Labour Organization' AND destGlobalClusters IS NULL THEN 'Early Recovery'
WHEN destOrganization = 'Malteser International Order of Malta World Relief' AND destGlobalClusters IS NULL THEN 'Multi-sector'
WHEN destOrganization = 'Humedica' AND destGlobalClusters IS NULL THEN 'Multi-sector'
WHEN destOrganization = 'International Organization for Migration' AND destGlobalClusters IS NULL THEN 'Multi-sector'
WHEN destOrganization = 'United Nations High Commissioner for Refugees' AND destGlobalClusters IS NULL THEN 'Multi-sector'
WHEN destOrganization = 'CARITAS' AND destGlobalClusters IS NULL THEN 'Multi-sector'
WHEN destOrganization = 'ACT Alliance / Diakonia, Sweden' AND destGlobalClusters IS NULL THEN 'Protection'
WHEN destOrganization = 'Finnish Red Cross' AND destGlobalClusters IS NULL THEN 'Multi-sector'
WHEN destOrganization = 'Swiss Development Cooperation/Swiss Humanitarian Aid' AND destGlobalClusters IS NULL THEN 'Protection'
WHEN destOrganization = 'United Nations Children''s Fund' AND destGlobalClusters IS NULL THEN 'Protection'
WHEN destOrganization = 'International Labour Organization' AND destGlobalClusters IS NULL THEN 'Early Recovery'
ELSE destGlobalClusters
END
WHERE destGlobalClusters IS NULL;

--Table 2: fts_requirements_funding_cluster_ken
SELECT * 
FROM fts_requirements_funding_cluster_ken
WHERE
countryCode IS NULL OR
id IS NULL OR
name IS NULL OR 
code IS NULL OR 
startDate IS NULL OR 
endDate IS NULL OR 
year IS NULL OR 
clusterCode IS NULL OR 
cluster IS NULL OR 
requirements IS NULL OR funding IS NULL OR
percentFunded IS NULL; -- the relevant columns are countrycode, id, name, code, cluster and funding

-- Table 3: fts_requirements_funding_covid_ken
SELECT COUNT(*) AS CountMissingValues --There is only one missing value in this table
FROM fts_requirements_funding_covid_ken
WHERE
countryCode IS NULL OR
id IS NULL OR
name is null
or code IS NULL OR
typeId IS NULL OR
typeName IS NULL OR
startDate IS NULL OR
endDate IS NULL OR
year IS NULL OR 
requirements IS NULL OR
funding IS NULL OR
covidFunding IS NULL OR
covidPercentageOfFunding IS NULL;

--Table 4: fts_requirements_funding_globalcluster_ken
SELECT COUNT(*) AS CountofNulls
FROM fts_requirements_funding_globalcluster_ken
WHERE
countryCode IS NULL OR
id IS NULL OR
name IS NULL OR
code IS NULL OR
startDate IS NULL OR
endDate IS NULL OR
year IS NULL OR 
clusterCode IS NULL OR 
cluster IS NULL OR
requirements IS NULL OR
funding IS NULL OR
percentFunded is null;

--Table 5:fts_requirements_funding_ken
SELECT COUNT(*) AS CountNulls
FROM fts_requirements_funding_ken
WHERE
countryCode IS NULL OR
id IS NULL OR 
name IS NULL OR 
code IS NULL OR 
typeId IS NULL OR
typeName IS NULL OR
startDate IS NULL OR 
endDate IS NULL OR 
year IS NULL OR 
requirements IS NULL OR 
funding IS NULL OR 
percentFunded IS NULL;


-- Update the Null values in typeName column
UPDATE fts_requirements_funding_ken
SET typeName = CASE
WHEN name = 'Not Specified' AND typeName IS NULL THEN 'Not specified'
ELSE typeName
END
WHERE typeName IS NULL;

--Checking for Duplicate Records
SELECT *, COUNT(*) AS DuplicateCount
FROM fts_incoming_funding_ken
GROUP BY 
date,
budgetYear,
description,
amountUSD,
srcOrganization,
srcOrganizationTypes,
srcLocations,
srcUsageYearStart,
srcUsageYearEnd,
destPlan,
destPlanCode,
destPlanId,
destOrganization,
destOrganizationTypes,
destGlobalClusters,
destLocations,
destProject,
destProjectCode,
destEmergency,
destUsageYearStart,
destUsageYearEnd,
contributionType,
flowType,
method,
boundary,
onBoundary,
status,
firstReportedDate,
decisionDate,
keywords,
originalAmount,
originalCurrency,
exchangeRate,
id,
refCode,
createdAt,
updatedAt
HAVING COUNT(*) > 1;

SELECT *,COUNT(*) AS Duplicate_Records
FROM fts_requirements_funding_ken
GROUP BY
countryCode,
id,
name,
code,
typeId,
typeName,
startDate,
endDate,
year,
requirements,
funding,
percentFunded
HAVING COUNT(*)>1;

SELECT *, COUNT(*) AS Duplicate_Count
FROM fts_requirements_funding_globalcluster_ken
GROUP BY
countryCode,
id,
name,
code,
startDate,
endDate,
year,
clusterCode,
cluster,
requirements,
funding,
percentFunded
HAVING COUNT(*)>1;

SELECT *, COUNT(*) AS Duplicate_Count
FROM fts_requirements_funding_cluster_ken 
GROUP BY
countryCode,
id,
name,
code,
startDate,
endDate,
year,
clusterCode,
cluster,
requirements,
funding,
percentFunded
HAVING COUNT(*)>1;

SELECT *, COUNT(*) AS Duplicate_Count
FROM fts_requirements_funding_covid_ken
GROUP BY
countryCode,
id,
name,
code,
typeId,
typeName,
startDate,
endDate,
year,
requirements,
funding,
covidFunding,
covidPercentageOfFunding
HAVING COUNT(*)>1;

--Create Indexes for Faster Querries
CREATE INDEX idx_incoming_budgetYear ON fts_incoming_funding_ken (budgetYear);
CREATE INDEX idx_cluster_year ON fts_requirements_funding_cluster_ken (year);
CREATE INDEX idx_cluster_funding ON fts_requirements_funding_cluster_ken (funding);
CREATE INDEX idx_covid_funding ON fts_requirements_funding_covid_ken (funding);
CREATE INDEX idx_globalcluster_funding ON fts_requirements_funding_globalcluster_ken (funding);

--Check the indexes
SELECT 
    i.name AS index_name, 
    t.name AS table_name 
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE t.name IN ('fts_requirements_funding_cluster_ken', 
                 'fts_requirements_funding_globalcluster_ken', 
                 'fts_incoming_funding_ken');
--Final Data Inspection
SELECT * FROM fts_incoming_funding_ken;
SELECT * FROM fts_requirements_funding_cluster_ken;
SELECT * FROM fts_requirements_funding_covid_ken;
SELECT * FROM fts_requirements_funding_globalcluster_ken;
SELECT * FROM fts_requirements_funding_ken;



SELECT
 rfk.name, 
 rfk.typeName,
 rfk.year,
 rfk.funding, 
 rfk.percentFunded, 
 rfc.covidFunding
FROM fts_requirements_funding_ken rfk
LEFT JOIN fts_requirements_funding_covid_ken rfc
ON rfk.funding=rfc.funding
WHERE rfk.year<2026;

SELECT
	rf.name, 
	rf.year, 
	rf.cluster, 
	rf.funding, 
	rf.percentFunded
FROM fts_requirements_funding_cluster_ken rf
INNER JOIN fts_requirements_funding_globalcluster_ken rfg
ON rf.funding=rfg.funding
WHERE rf.year<2026;


--Yearly funding

select budgetYear,sum(cast(amountUSD as float))
from fts_incoming_funding_ken
--where budgetYear is not null
group by budgetYear
order by budgetYear;

--Total funding per organization types
SELECT 
	srcOrganizationTypes,
	sum(amountUSD) as TotalFunding
FROM fts_incoming_funding_ken
--where budgetYear is not null
GROUP BY srcOrganizationTypes
ORDER BY srcOrganizationTypes;

select budgetYear,sum(amountUSD) as TotalFunding, destOrganizationTypes
from fts_incoming_funding_ken
where budgetYear is not null and destOrganizationTypes is not null
group by budgetYear,destOrganizationTypes
order by budgetYear;

SELECT 
	budgetYear,
	sum(amountUSD) as TotalFunding, 
	destOrganization
FROM fts_incoming_funding_ken
WHERE budgetYear is not null and destOrganization is not null
GROUP BY budgetYear,destOrganization
ORDER BY budgetYear;

SELECT 
	destOrganization,
	sum(amountUSD) as TotalFunding
FROM fts_incoming_funding_ken
WHERE destOrganization is not null
GROUP BY destOrganization
ORDER BY TotalFunding DESC;

SELECT 
	destOrganizationTypes,
	sum(amountUSD) as TotalFunding
FROM fts_incoming_funding_ken
WHERE destOrganizationTypes is not null
GROUP BY destOrganizationTypes
ORDER BY TotalFunding DESC;

--Funding Per srcOrganization
SELECT 
	srcOrganization,
	sum(amountUSD) as TotalFunding
FROM fts_incoming_funding_ken
WHERE srcOrganization is not null
GROUP BY srcOrganization
ORDER BY srcOrganization;



SELECT 
	destOrganization,
	sum(amountUSD) as TotalFunding
FROM fts_incoming_funding_ken
WHERE destOrganization is not null
GROUP BY destOrganization
ORDER BY TotalFunding DESC;


