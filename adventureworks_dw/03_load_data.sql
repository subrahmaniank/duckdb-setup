-- 03_load_data.sql
-- Purpose: Load AdventureWorksDW CSV data into DuckDB tables
-- Note: Paths are relative to database directory (or parameterized by build script)

COPY DatabaseLog FROM 'data/DatabaseLog.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimAccount FROM 'data/DimAccount.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimCurrency FROM 'data/DimCurrency.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimCustomer FROM 'data/DimCustomer.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimDate FROM 'data/DimDate.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimDepartmentGroup FROM 'data/DimDepartmentGroup.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimEmployee FROM 'data/DimEmployee.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimGeography FROM 'data/DimGeography.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimOrganization FROM 'data/DimOrganization.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimProduct FROM 'data/DimProduct.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimProductCategory FROM 'data/DimProductCategory.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimProductSubcategory FROM 'data/DimProductSubcategory.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimPromotion FROM 'data/DimPromotion.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimReseller FROM 'data/DimReseller.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimSalesReason FROM 'data/DimSalesReason.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimSalesTerritory FROM 'data/DimSalesTerritory.csv' (DELIMITER '|', HEADER false, NULL '');
COPY DimScenario FROM 'data/DimScenario.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactAdditionalInternationalProductDescription FROM 'data/FactAdditionalInternationalProductDescription.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactCallCenter FROM 'data/FactCallCenter.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactCurrencyRate FROM 'data/FactCurrencyRate.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactFinance FROM 'data/FactFinance.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactInternetSales FROM 'data/FactInternetSales.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactInternetSalesReason FROM 'data/FactInternetSalesReason.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactProductInventory FROM 'data/FactProductInventory.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactResellerSales FROM 'data/FactResellerSales.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactSalesQuota FROM 'data/FactSalesQuota.csv' (DELIMITER '|', HEADER false, NULL '');
COPY FactSurveyResponse FROM 'data/FactSurveyResponse.csv' (DELIMITER '|', HEADER false, NULL '');
COPY NewFactCurrencyRate FROM 'data/NewFactCurrencyRate.csv' (DELIMITER '|', HEADER false, NULL '');
COPY ProspectiveBuyer FROM 'data/ProspectiveBuyer.csv' (DELIMITER '|', HEADER false, NULL '');
