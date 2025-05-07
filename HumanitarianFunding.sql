-- Use the appropriate database
USE [HumanitarianFunding];

-- List all tables
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- Inspect table structure
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_incoming_funding_ken';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_requirements_funding_ken';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_requirements_funding_covid_ken';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_requirements_funding_cluster_ken';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fts_requirements_funding_globalcluster_ken';

-- Check for NULL values in all tables
-- Table: fts_incoming_funding_ken
SELECT *
FROM fts_incoming_funding_ken
WHERE date IS NULL
   OR budgetYear IS NULL
   OR description IS NULL
   OR amountUSD IS NULL
   OR srcOrganization IS NULL
   OR srcOrganizationTypes IS NULL
   OR srcLocations IS NULL
   OR srcUsageYearStart IS NULL
   OR srcUsageYearEnd IS NULL
   OR destOrganization IS NULL
   OR destOrganizationTypes IS NULL
   OR destGlobalClusters IS NULL
   OR destLocations IS NULL
   OR id IS NULL;

-- Update NULL values
UPDATE fts_incoming_funding_ken
SET budgetYear = CASE
    WHEN MONTH(date) >= 7 THEN YEAR(date)
    ELSE YEAR(date) - 1
END
WHERE budgetYear IS NULL AND date IS NOT NULL;

UPDATE fts_incoming_funding_ken
SET srcLocations = CASE
    WHEN srcOrganization = 'European Commission' AND srcLocations IS NULL THEN 'BELG'
    WHEN srcOrganization = 'Save the Children' AND srcLocations IS NULL THEN 'USA'
    ELSE srcLocations
END
WHERE srcLocations IS NULL;

UPDATE fts_incoming_funding_ken
SET destOrganization = CASE
    WHEN srcOrganization = 'United States of America, Government of' AND destOrganization IS NULL THEN 'Governments'
    ELSE destOrganization
END
WHERE destOrganization IS NULL;

UPDATE fts_incoming_funding_ken
SET destOrganizationTypes = CASE
    WHEN destOrganization = 'Governments' AND destOrganizationTypes IS NULL THEN 'Governments'
    ELSE destOrganizationTypes
END
WHERE destOrganizationTypes IS NULL;

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

-- Table: fts_requirements_funding_cluster_ken
SELECT *
FROM fts_requirements_funding_cluster_ken
WHERE countryCode IS NULL
   OR id IS NULL
   OR name IS NULL
   OR code IS NULL
   OR startDate IS NULL
   OR endDate IS NULL
   OR year IS NULL
   OR clusterCode IS NULL
   OR cluster IS NULL
   OR requirements IS NULL
   OR funding IS NULL
   OR percentFunded IS NULL;

-- Table: fts_requirements_funding_covid_ken
SELECT COUNT(*) AS CountMissingValues
FROM fts_requirements_funding_covid_ken
WHERE countryCode IS NULL
   OR id IS NULL
   OR name IS NULL
   OR code IS NULL
   OR typeId IS NULL
   OR typeName IS NULL
   OR startDate IS NULL
   OR endDate IS NULL
   OR year IS NULL
   OR requirements IS NULL
   OR funding IS NULL
   OR covidFunding IS NULL
   OR covidPercentageOfFunding IS NULL;

-- Table: fts_requirements_funding_globalcluster_ken
SELECT COUNT(*) AS CountofNulls
FROM fts_requirements_funding_globalcluster_ken
WHERE countryCode IS NULL
   OR id IS NULL
   OR name IS NULL
   OR code IS NULL
   OR startDate IS NULL
   OR endDate IS NULL
   OR year IS NULL
   OR clusterCode IS NULL
   OR cluster IS NULL
   OR requirements IS NULL
   OR funding IS NULL
   OR percentFunded IS NULL;

-- Table: fts_requirements_funding_ken
SELECT COUNT(*) AS CountNulls
FROM fts_requirements_funding_ken
WHERE countryCode IS NULL
   OR id IS NULL
   OR name IS NULL
   OR code IS NULL
   OR typeId IS NULL
   OR typeName IS NULL
   OR startDate IS NULL
   OR endDate IS NULL
   OR year IS NULL
   OR requirements IS NULL
   OR funding IS NULL
   OR percentFunded IS NULL;

UPDATE fts_requirements_funding_ken
SET typeName = CASE
    WHEN name = 'Not Specified' AND typeName IS NULL THEN 'Not specified'
    ELSE typeName
END
WHERE typeName IS NULL;

-- Check for duplicate records
SELECT *, COUNT(*) AS DuplicateCount
FROM fts_incoming_funding_ken
GROUP BY date,
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

SELECT *, COUNT(*) AS Duplicate_Records
FROM fts_requirements_funding_ken
GROUP BY countryCode,
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
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) AS Duplicate_Count
FROM fts_requirements_funding_globalcluster_ken
GROUP BY countryCode,
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
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) AS Duplicate_Count
FROM fts_requirements_funding_cluster_ken
GROUP BY countryCode,
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
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) AS Duplicate_Count
FROM fts_requirements_funding_covid_ken
GROUP BY countryCode,
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
HAVING COUNT(*) > 1;

-- Optimize indexes for faster queries
CREATE INDEX idx_budget_year ON fts_incoming_funding_ken (budgetYear);
CREATE INDEX idx_funding ON fts_requirements_funding_cluster_ken (funding);
CREATE INDEX idx_covid_funding ON fts_requirements_funding_covid_ken (funding);
CREATE INDEX idx_globalcluster_funding ON fts_requirements_funding_globalcluster_ken (funding);

-- Check the indexes
SELECT name AS index_name, object_name(object_id) AS table_name
FROM sys.indexes
WHERE object_name(object_id) IN ('fts_requirements_funding_cluster_ken',
                                 'fts_requirements_funding_globalcluster_ken',
                                 'fts_incoming_funding_ken');

-- Final data inspection
SELECT TOP 10 * FROM fts_incoming_funding_ken;
SELECT TOP 10 * FROM fts_requirements_funding_cluster_ken;
SELECT TOP 10 * FROM fts_requirements_funding_covid_ken;
SELECT TOP 10 * FROM fts_requirements_funding_globalcluster_ken;
SELECT TOP 10 * FROM fts_requirements_funding_ken;

-- Analyze yearly funding
SELECT budgetYear, SUM(amountUSD) AS total_funding
FROM fts_incoming_funding_ken
GROUP BY budgetYear
ORDER BY budgetYear;

-- Total funding by organization type
SELECT srcOrganizationTypes, SUM(amountUSD) AS total_funding
FROM fts_incoming_funding_ken
GROUP BY srcOrganizationTypes
ORDER BY total_funding DESC;

SELECT budgetYear, SUM(amountUSD) AS total_funding, destOrganizationTypes
FROM fts_incoming_funding_ken
WHERE budgetYear IS NOT NULL AND destOrganizationTypes IS NOT NULL
GROUP BY budgetYear, destOrganizationTypes
ORDER BY budgetYear;

SELECT budgetYear, SUM(amountUSD) AS total_funding, destOrganization
FROM fts_incoming_funding_ken
WHERE budgetYear IS NOT NULL AND destOrganization IS NOT NULL
GROUP BY budgetYear, destOrganization
ORDER BY budgetYear;

-- Funding by destination organization
SELECT destOrganization, SUM(amountUSD) AS total_funding
FROM fts_incoming_funding_ken
WHERE destOrganization IS NOT NULL
GROUP BY destOrganization
ORDER BY total_funding DESC;

SELECT destOrganizationTypes, SUM(amountUSD) AS total_funding
FROM fts_incoming_funding_ken
WHERE destOrganizationTypes IS NOT NULL
GROUP BY destOrganizationTypes
ORDER BY total_funding DESC;

-- Funding by source organization
SELECT srcOrganization, SUM(amountUSD) AS total_funding
FROM fts_incoming_funding_ken
WHERE srcOrganization IS NOT NULL
GROUP BY srcOrganization
ORDER BY srcOrganization;

SELECT destOrganization, SUM(amountUSD) AS total_funding
FROM fts_incoming_funding_ken
WHERE destOrganization IS NOT NULL
GROUP BY destOrganization
ORDER BY total_funding DESC;


