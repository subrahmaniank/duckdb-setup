-- 02_create_tables.sql
-- Purpose: Create Tables for AdventureWorksDW in DuckDB

CREATE TABLE IF NOT EXISTS AdventureWorksDWBuildVersion (
    DBVersion VARCHAR(50),
    VersionDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS DimAccount (
    AccountKey INTEGER NOT NULL PRIMARY KEY,
    ParentAccountKey INTEGER,
    AccountCodeAlternateKey INTEGER,
    ParentAccountCodeAlternateKey INTEGER,
    AccountDescription VARCHAR(50),
    AccountType VARCHAR(50),
    Operator VARCHAR(50),
    CustomMembers VARCHAR(300),
    ValueType VARCHAR(50),
    CustomMemberOptions VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS DimCurrency (
    CurrencyKey INTEGER NOT NULL PRIMARY KEY,
    CurrencyAlternateKey VARCHAR(3) NOT NULL,
    CurrencyName VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS DimCustomer (
    CustomerKey INTEGER NOT NULL PRIMARY KEY,
    GeographyKey INTEGER,
    CustomerAlternateKey VARCHAR(15) NOT NULL,
    Title VARCHAR(8),
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    NameStyle BOOLEAN,
    BirthDate DATE,
    MaritalStatus VARCHAR(1),
    Suffix VARCHAR(10),
    Gender VARCHAR(1),
    EmailAddress VARCHAR(50),
    YearlyIncome DECIMAL(19,4),
    TotalChildren INTEGER,
    NumberChildrenAtHome INTEGER,
    EnglishEducation VARCHAR(40),
    SpanishEducation VARCHAR(40),
    FrenchEducation VARCHAR(40),
    EnglishOccupation VARCHAR(100),
    SpanishOccupation VARCHAR(100),
    FrenchOccupation VARCHAR(100),
    HouseOwnerFlag VARCHAR(1),
    NumberCarsOwned INTEGER,
    AddressLine1 VARCHAR(120),
    AddressLine2 VARCHAR(120),
    Phone VARCHAR(20),
    DateFirstPurchase DATE,
    CommuteDistance VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS DimDate (
    DateKey INTEGER NOT NULL PRIMARY KEY,
    FullDateAlternateKey DATE NOT NULL,
    DayNumberOfWeek INTEGER NOT NULL,
    EnglishDayNameOfWeek VARCHAR(10) NOT NULL,
    SpanishDayNameOfWeek VARCHAR(10) NOT NULL,
    FrenchDayNameOfWeek VARCHAR(10) NOT NULL,
    DayNumberOfMonth INTEGER NOT NULL,
    DayNumberOfYear INTEGER NOT NULL,
    WeekNumberOfYear INTEGER NOT NULL,
    EnglishMonthName VARCHAR(10) NOT NULL,
    SpanishMonthName VARCHAR(10) NOT NULL,
    FrenchMonthName VARCHAR(10) NOT NULL,
    MonthNumberOfYear INTEGER NOT NULL,
    CalendarQuarter INTEGER NOT NULL,
    CalendarYear INTEGER NOT NULL,
    CalendarSemester INTEGER NOT NULL,
    FiscalQuarter INTEGER NOT NULL,
    FiscalYear INTEGER NOT NULL,
    FiscalSemester INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS DimDepartmentGroup (
    DepartmentGroupKey INTEGER NOT NULL PRIMARY KEY,
    ParentDepartmentGroupKey INTEGER,
    DepartmentGroupName VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS DimEmployee (
    EmployeeKey INTEGER NOT NULL PRIMARY KEY,
    ParentEmployeeKey INTEGER,
    EmployeeNationalIDAlternateKey VARCHAR(15),
    ParentEmployeeNationalIDAlternateKey VARCHAR(15),
    SalesTerritoryKey INTEGER,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    NameStyle BOOLEAN NOT NULL,
    Title VARCHAR(50),
    HireDate DATE,
    BirthDate DATE,
    LoginID VARCHAR(256),
    EmailAddress VARCHAR(50),
    Phone VARCHAR(25),
    MaritalStatus VARCHAR(1),
    EmergencyContactName VARCHAR(50),
    EmergencyContactPhone VARCHAR(25),
    SalariedFlag BOOLEAN,
    Gender VARCHAR(1),
    PayFrequency INTEGER,
    BaseRate DECIMAL(19,4),
    VacationHours INTEGER,
    SickLeaveHours INTEGER,
    CurrentFlag BOOLEAN NOT NULL,
    SalesPersonFlag BOOLEAN NOT NULL,
    DepartmentName VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50),
    EmployeePhoto BLOB
);

CREATE TABLE IF NOT EXISTS DimGeography (
    GeographyKey INTEGER NOT NULL PRIMARY KEY,
    City VARCHAR(30),
    StateProvinceCode VARCHAR(3),
    StateProvinceName VARCHAR(50),
    CountryRegionCode VARCHAR(3),
    EnglishCountryRegionName VARCHAR(50),
    SpanishCountryRegionName VARCHAR(50),
    FrenchCountryRegionName VARCHAR(50),
    PostalCode VARCHAR(15),
    SalesTerritoryKey INTEGER,
    IpAddressLocator VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS DimOrganization (
    OrganizationKey INTEGER NOT NULL PRIMARY KEY,
    ParentOrganizationKey INTEGER,
    PercentageOfOwnership VARCHAR(16),
    OrganizationName VARCHAR(50),
    CurrencyKey INTEGER
);

CREATE TABLE IF NOT EXISTS DimProduct (
    ProductKey INTEGER NOT NULL PRIMARY KEY,
    ProductAlternateKey VARCHAR(25),
    ProductSubcategoryKey INTEGER,
    WeightUnitMeasureCode VARCHAR(3),
    SizeUnitMeasureCode VARCHAR(3),
    EnglishProductName VARCHAR(50) NOT NULL,
    SpanishProductName VARCHAR(50) NOT NULL,
    FrenchProductName VARCHAR(50) NOT NULL,
    StandardCost DECIMAL(19,4),
    FinishedGoodsFlag BOOLEAN NOT NULL,
    Color VARCHAR(15) NOT NULL,
    SafetyStockLevel INTEGER,
    ReorderPoint INTEGER,
    ListPrice DECIMAL(19,4),
    Size VARCHAR(50),
    SizeRange VARCHAR(50),
    Weight DOUBLE,
    DaysToManufacture INTEGER,
    ProductLine VARCHAR(2),
    DealerPrice DECIMAL(19,4),
    Class VARCHAR(2),
    Style VARCHAR(2),
    ModelName VARCHAR(50),
    LargePhoto BLOB,
    EnglishDescription VARCHAR(400),
    FrenchDescription VARCHAR(400),
    ChineseDescription VARCHAR(400),
    ArabicDescription VARCHAR(400),
    HebrewDescription VARCHAR(400),
    ThaiDescription VARCHAR(400),
    GermanDescription VARCHAR(400),
    JapaneseDescription VARCHAR(400),
    TurkishDescription VARCHAR(400),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    Status VARCHAR(7)
);

CREATE TABLE IF NOT EXISTS DimProductCategory (
    ProductCategoryKey INTEGER NOT NULL PRIMARY KEY,
    ProductCategoryAlternateKey INTEGER,
    EnglishProductCategoryName VARCHAR(50) NOT NULL,
    SpanishProductCategoryName VARCHAR(50) NOT NULL,
    FrenchProductCategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS DimProductSubcategory (
    ProductSubcategoryKey INTEGER NOT NULL PRIMARY KEY,
    ProductSubcategoryAlternateKey INTEGER,
    EnglishProductSubcategoryName VARCHAR(50) NOT NULL,
    SpanishProductSubcategoryName VARCHAR(50) NOT NULL,
    FrenchProductSubcategoryName VARCHAR(50) NOT NULL,
    ProductCategoryKey INTEGER
);

CREATE TABLE IF NOT EXISTS DimPromotion (
    PromotionKey INTEGER NOT NULL PRIMARY KEY,
    PromotionAlternateKey INTEGER,
    EnglishPromotionName VARCHAR(255),
    SpanishPromotionName VARCHAR(255),
    FrenchPromotionName VARCHAR(255),
    DiscountPct DOUBLE,
    EnglishPromotionType VARCHAR(50),
    SpanishPromotionType VARCHAR(50),
    FrenchPromotionType VARCHAR(50),
    EnglishPromotionCategory VARCHAR(50),
    SpanishPromotionCategory VARCHAR(50),
    FrenchPromotionCategory VARCHAR(50),
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP,
    MinQty INTEGER,
    MaxQty INTEGER
);

CREATE TABLE IF NOT EXISTS DimReseller (
    ResellerKey INTEGER NOT NULL PRIMARY KEY,
    GeographyKey INTEGER,
    ResellerAlternateKey VARCHAR(15),
    Phone VARCHAR(25),
    BusinessType VARCHAR(20) NOT NULL,
    ResellerName VARCHAR(50) NOT NULL,
    NumberEmployees INTEGER,
    OrderFrequency VARCHAR(1),
    OrderMonth INTEGER,
    FirstOrderYear INTEGER,
    LastOrderYear INTEGER,
    ProductLine VARCHAR(50),
    AddressLine1 VARCHAR(60),
    AddressLine2 VARCHAR(60),
    AnnualSales DECIMAL(19,4),
    BankName VARCHAR(50),
    MinPaymentType INTEGER,
    MinPaymentAmount DECIMAL(19,4),
    AnnualRevenue DECIMAL(19,4),
    YearOpened INTEGER
);

CREATE TABLE IF NOT EXISTS DimSalesReason (
    SalesReasonKey INTEGER NOT NULL PRIMARY KEY,
    SalesReasonAlternateKey INTEGER NOT NULL,
    SalesReasonName VARCHAR(50) NOT NULL,
    SalesReasonReasonType VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS DimSalesTerritory (
    SalesTerritoryKey INTEGER NOT NULL PRIMARY KEY,
    SalesTerritoryAlternateKey INTEGER,
    SalesTerritoryRegion VARCHAR(50) NOT NULL,
    SalesTerritoryCountry VARCHAR(50) NOT NULL,
    SalesTerritoryGroup VARCHAR(50),
    SalesTerritoryImage BLOB
);

CREATE TABLE IF NOT EXISTS DimScenario (
    ScenarioKey INTEGER NOT NULL PRIMARY KEY,
    ScenarioName VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS FactAdditionalInternationalProductDescription (
    ProductKey INTEGER NOT NULL,
    CultureName VARCHAR(50) NOT NULL,
    ProductDescription VARCHAR,
    PRIMARY KEY (ProductKey, CultureName)
);

CREATE TABLE IF NOT EXISTS FactCallCenter (
    FactCallCenterID INTEGER NOT NULL PRIMARY KEY,
    DateKey INTEGER NOT NULL,
    WageType VARCHAR(15) NOT NULL,
    Shift VARCHAR(20) NOT NULL,
    LevelOneOperators INTEGER NOT NULL,
    LevelTwoOperators INTEGER NOT NULL,
    TotalOperators INTEGER NOT NULL,
    Calls INTEGER NOT NULL,
    AutomaticResponses INTEGER NOT NULL,
    Orders INTEGER NOT NULL,
    IssuesRaised INTEGER NOT NULL,
    AverageTimePerIssue INTEGER NOT NULL,
    ServiceGrade DOUBLE NOT NULL,
    Date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS FactCurrencyRate (
    CurrencyKey INTEGER NOT NULL,
    DateKey INTEGER NOT NULL,
    AverageRate DOUBLE NOT NULL,
    EndOfDayRate DOUBLE NOT NULL,
    Date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS FactFinance (
    FinanceKey INTEGER NOT NULL,
    DateKey INTEGER NOT NULL,
    OrganizationKey INTEGER NOT NULL,
    DepartmentGroupKey INTEGER NOT NULL,
    ScenarioKey INTEGER NOT NULL,
    AccountKey INTEGER NOT NULL,
    Amount DOUBLE NOT NULL,
    Date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS FactInternetSales (
    ProductKey INTEGER NOT NULL,
    OrderDateKey INTEGER NOT NULL,
    DueDateKey INTEGER NOT NULL,
    ShipDateKey INTEGER NOT NULL,
    CustomerKey INTEGER NOT NULL,
    PromotionKey INTEGER NOT NULL,
    CurrencyKey INTEGER NOT NULL,
    SalesTerritoryKey INTEGER NOT NULL,
    SalesOrderNumber VARCHAR(20) NOT NULL,
    SalesOrderLineNumber INTEGER NOT NULL,
    RevisionNumber INTEGER NOT NULL,
    OrderQuantity INTEGER NOT NULL,
    UnitPrice DECIMAL(19,4) NOT NULL,
    ExtendedAmount DECIMAL(19,4) NOT NULL,
    UnitPriceDiscountPct DOUBLE NOT NULL,
    DiscountAmount DOUBLE NOT NULL,
    ProductStandardCost DECIMAL(19,4) NOT NULL,
    TotalProductCost DECIMAL(19,4) NOT NULL,
    SalesAmount DECIMAL(19,4) NOT NULL,
    TaxAmt DECIMAL(19,4) NOT NULL,
    Freight DECIMAL(19,4) NOT NULL,
    CarrierTrackingNumber VARCHAR(25),
    CustomerPONumber VARCHAR(25),
    OrderDate TIMESTAMP,
    DueDate TIMESTAMP,
    ShipDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS FactInternetSalesReason (
    SalesOrderNumber VARCHAR(20) NOT NULL,
    SalesOrderLineNumber INTEGER NOT NULL,
    SalesReasonKey INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS FactProductInventory (
    ProductKey INTEGER NOT NULL,
    DateKey INTEGER NOT NULL,
    MovementDate DATE NOT NULL,
    UnitCost DECIMAL(19,4) NOT NULL,
    UnitsIn INTEGER NOT NULL,
    UnitsOut INTEGER NOT NULL,
    UnitsBalance INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS FactResellerSales (
    ProductKey INTEGER NOT NULL,
    OrderDateKey INTEGER NOT NULL,
    DueDateKey INTEGER NOT NULL,
    ShipDateKey INTEGER NOT NULL,
    ResellerKey INTEGER NOT NULL,
    EmployeeKey INTEGER NOT NULL,
    PromotionKey INTEGER NOT NULL,
    CurrencyKey INTEGER NOT NULL,
    SalesTerritoryKey INTEGER NOT NULL,
    SalesOrderNumber VARCHAR(20) NOT NULL,
    SalesOrderLineNumber INTEGER NOT NULL,
    RevisionNumber INTEGER,
    OrderQuantity INTEGER,
    UnitPrice DECIMAL(19,4),
    ExtendedAmount DECIMAL(19,4),
    UnitPriceDiscountPct DOUBLE,
    DiscountAmount DOUBLE,
    ProductStandardCost DECIMAL(19,4),
    TotalProductCost DECIMAL(19,4),
    SalesAmount DECIMAL(19,4),
    TaxAmt DECIMAL(19,4),
    Freight DECIMAL(19,4),
    CarrierTrackingNumber VARCHAR(25),
    CustomerPONumber VARCHAR(25),
    OrderDate TIMESTAMP,
    DueDate TIMESTAMP,
    ShipDate TIMESTAMP
);

CREATE TABLE IF NOT EXISTS FactSalesQuota (
    SalesQuotaKey INTEGER NOT NULL,
    EmployeeKey INTEGER NOT NULL,
    DateKey INTEGER NOT NULL,
    CalendarYear INTEGER NOT NULL,
    CalendarQuarter INTEGER NOT NULL,
    SalesAmountQuota DECIMAL(19,4) NOT NULL,
    Date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS FactSurveyResponse (
    SurveyResponseKey INTEGER NOT NULL,
    DateKey INTEGER NOT NULL,
    CustomerKey INTEGER NOT NULL,
    ProductCategoryKey INTEGER NOT NULL,
    EnglishProductCategoryName VARCHAR(50) NOT NULL,
    ProductSubcategoryKey INTEGER NOT NULL,
    EnglishProductSubcategoryName VARCHAR(50) NOT NULL,
    Date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS NewFactCurrencyRate (
    AverageRate DOUBLE,
    CurrencyID VARCHAR(3),
    CurrencyDate DATE,
    EndOfDayRate DOUBLE,
    CurrencyKey INTEGER,
    DateKey INTEGER
);

CREATE TABLE IF NOT EXISTS ProspectiveBuyer (
    ProspectiveBuyerKey INTEGER NOT NULL,
    ProspectAlternateKey VARCHAR(15),
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate TIMESTAMP,
    MaritalStatus VARCHAR(1),
    Gender VARCHAR(1),
    EmailAddress VARCHAR(50),
    YearlyIncome DECIMAL(19,4),
    TotalChildren INTEGER,
    NumberChildrenAtHome INTEGER,
    Education VARCHAR(40),
    Occupation VARCHAR(100),
    HouseOwnerFlag VARCHAR(1),
    NumberCarsOwned INTEGER,
    AddressLine1 VARCHAR(120),
    AddressLine2 VARCHAR(120),
    City VARCHAR(30),
    StateProvinceCode VARCHAR(3),
    PostalCode VARCHAR(15),
    Phone VARCHAR(20),
    Salutation VARCHAR(8),
    Unknown INTEGER
);

CREATE TABLE IF NOT EXISTS DatabaseLog (
    DatabaseLogID INTEGER NOT NULL,
    PostTime TIMESTAMP NOT NULL,
    DatabaseUser VARCHAR(128) NOT NULL,
    Event VARCHAR(128) NOT NULL,
    Schema VARCHAR(128),
    Object VARCHAR(128),
    TSQL VARCHAR,
    XmlEvent VARCHAR NOT NULL
);
