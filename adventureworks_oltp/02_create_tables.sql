-- 02_create_tables.sql
-- Purpose: Create Tables for AdventureWorks OLTP in DuckDB

-- =============================================
-- Public Schema Tables
-- =============================================

CREATE TABLE IF NOT EXISTS public.DatabaseLog (
    DatabaseLogID INTEGER NOT NULL,
    PostTime TIMESTAMP NOT NULL,
    DatabaseUser VARCHAR(128) NOT NULL,
    Event VARCHAR(128) NOT NULL,
    Schema VARCHAR(128),
    Object VARCHAR(128),
    TSQL VARCHAR,
    XmlEvent VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS public.ErrorLog (
    ErrorLogID INTEGER NOT NULL,
    ErrorTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UserName VARCHAR(128) NOT NULL,
    ErrorNumber INTEGER NOT NULL,
    ErrorSeverity INTEGER,
    ErrorState INTEGER,
    ErrorProcedure VARCHAR(126),
    ErrorLine INTEGER,
    ErrorMessage VARCHAR(4000) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.AWBuildVersion (
    SystemInformationID INTEGER NOT NULL,
    DatabaseVersion VARCHAR(25) NOT NULL,
    VersionDate TIMESTAMP NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Person Schema Tables
-- =============================================

CREATE TABLE IF NOT EXISTS person.Address (
    AddressID INTEGER NOT NULL,
    AddressLine1 VARCHAR(60) NOT NULL,
    AddressLine2 VARCHAR(60),
    City VARCHAR(30) NOT NULL,
    StateProvinceID INTEGER NOT NULL,
    PostalCode VARCHAR(15) NOT NULL,
    SpatialLocation VARCHAR,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.AddressType (
    AddressTypeID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.BusinessEntity (
    BusinessEntityID INTEGER NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.BusinessEntityAddress (
    BusinessEntityID INTEGER NOT NULL,
    AddressID INTEGER NOT NULL,
    AddressTypeID INTEGER NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.BusinessEntityContact (
    BusinessEntityID INTEGER NOT NULL,
    PersonID INTEGER NOT NULL,
    ContactTypeID INTEGER NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.ContactType (
    ContactTypeID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.CountryRegion (
    CountryRegionCode VARCHAR(3) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.EmailAddress (
    BusinessEntityID INTEGER NOT NULL,
    EmailAddressID INTEGER NOT NULL,
    EmailAddress VARCHAR(50),
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.Password (
    BusinessEntityID INTEGER NOT NULL,
    PasswordHash VARCHAR(128) NOT NULL,
    PasswordSalt VARCHAR(10) NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.Person (
    BusinessEntityID INTEGER NOT NULL,
    PersonType VARCHAR(2) NOT NULL,
    NameStyle BOOLEAN NOT NULL DEFAULT FALSE,
    Title VARCHAR(8),
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    LastName VARCHAR(50) NOT NULL,
    Suffix VARCHAR(10),
    EmailPromotion INTEGER NOT NULL DEFAULT 0,
    AdditionalContactInfo VARCHAR,
    Demographics VARCHAR,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.PersonPhone (
    BusinessEntityID INTEGER NOT NULL,
    PhoneNumber VARCHAR(25) NOT NULL,
    PhoneNumberTypeID INTEGER NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.PhoneNumberType (
    PhoneNumberTypeID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS person.StateProvince (
    StateProvinceID INTEGER NOT NULL,
    StateProvinceCode VARCHAR(3) NOT NULL,
    CountryRegionCode VARCHAR(3) NOT NULL,
    IsOnlyStateProvinceFlag BOOLEAN NOT NULL DEFAULT TRUE,
    Name VARCHAR(50) NOT NULL,
    TerritoryID INTEGER NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- HumanResources Schema Tables
-- =============================================

CREATE TABLE IF NOT EXISTS humanresources.Department (
    DepartmentID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    GroupName VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS humanresources.Employee (
    BusinessEntityID INTEGER NOT NULL,
    NationalIDNumber VARCHAR(15) NOT NULL,
    LoginID VARCHAR(256) NOT NULL,
    OrganizationNode VARCHAR,
    OrganizationLevel INTEGER,
    JobTitle VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    MaritalStatus VARCHAR(1) NOT NULL,
    Gender VARCHAR(1) NOT NULL,
    HireDate DATE NOT NULL,
    SalariedFlag BOOLEAN NOT NULL DEFAULT TRUE,
    VacationHours INTEGER NOT NULL DEFAULT 0,
    SickLeaveHours INTEGER NOT NULL DEFAULT 0,
    CurrentFlag BOOLEAN NOT NULL DEFAULT TRUE,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS humanresources.EmployeeDepartmentHistory (
    BusinessEntityID INTEGER NOT NULL,
    DepartmentID INTEGER NOT NULL,
    ShiftID INTEGER NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS humanresources.EmployeePayHistory (
    BusinessEntityID INTEGER NOT NULL,
    RateChangeDate TIMESTAMP NOT NULL,
    Rate DECIMAL(19,4) NOT NULL,
    PayFrequency INTEGER NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS humanresources.JobCandidate (
    JobCandidateID INTEGER NOT NULL,
    BusinessEntityID INTEGER,
    Resume VARCHAR,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS humanresources.Shift (
    ShiftID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    StartTime VARCHAR(16) NOT NULL,
    EndTime VARCHAR(16) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Production Schema Tables
-- =============================================

CREATE TABLE IF NOT EXISTS production.BillOfMaterials (
    BillOfMaterialsID INTEGER NOT NULL,
    ProductAssemblyID INTEGER,
    ComponentID INTEGER NOT NULL,
    StartDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EndDate TIMESTAMP,
    UnitMeasureCode VARCHAR(3) NOT NULL,
    BOMLevel INTEGER NOT NULL,
    PerAssemblyQty DECIMAL(8,2) NOT NULL DEFAULT 1.00,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.Culture (
    CultureID VARCHAR(6) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.Document (
    DocumentNode VARCHAR NOT NULL,
    DocumentLevel INTEGER,
    Title VARCHAR(50) NOT NULL,
    Owner INTEGER NOT NULL,
    FolderFlag BOOLEAN NOT NULL DEFAULT FALSE,
    FileName VARCHAR(400) NOT NULL,
    FileExtension VARCHAR(8) NOT NULL,
    Revision VARCHAR(5) NOT NULL,
    ChangeNumber INTEGER NOT NULL DEFAULT 0,
    Status INTEGER NOT NULL DEFAULT 1,
    DocumentSummary VARCHAR,
    Document BLOB,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.Illustration (
    IllustrationID INTEGER NOT NULL,
    Diagram VARCHAR,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.Location (
    LocationID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    CostRate DECIMAL(10,4) NOT NULL DEFAULT 0.00,
    Availability DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.Product (
    ProductID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ProductNumber VARCHAR(25) NOT NULL,
    MakeFlag BOOLEAN NOT NULL DEFAULT TRUE,
    FinishedGoodsFlag BOOLEAN NOT NULL DEFAULT TRUE,
    Color VARCHAR(15),
    SafetyStockLevel INTEGER NOT NULL,
    ReorderPoint INTEGER NOT NULL,
    StandardCost DECIMAL(19,4) NOT NULL,
    ListPrice DECIMAL(19,4) NOT NULL,
    Size VARCHAR(5),
    SizeUnitMeasureCode VARCHAR(3),
    WeightUnitMeasureCode VARCHAR(3),
    Weight DECIMAL(8,2),
    DaysToManufacture INTEGER NOT NULL,
    ProductLine VARCHAR(2),
    Class VARCHAR(2),
    Style VARCHAR(2),
    ProductSubcategoryID INTEGER,
    ProductModelID INTEGER,
    SellStartDate TIMESTAMP NOT NULL,
    SellEndDate TIMESTAMP,
    DiscontinuedDate TIMESTAMP,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductCategory (
    ProductCategoryID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductCostHistory (
    ProductID INTEGER NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP,
    StandardCost DECIMAL(19,4) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductDescription (
    ProductDescriptionID INTEGER NOT NULL,
    Description VARCHAR(400) NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductDocument (
    ProductID INTEGER NOT NULL,
    DocumentNode VARCHAR NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductInventory (
    ProductID INTEGER NOT NULL,
    LocationID INTEGER NOT NULL,
    Shelf VARCHAR(10) NOT NULL,
    Bin INTEGER NOT NULL,
    Quantity INTEGER NOT NULL DEFAULT 0,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductListPriceHistory (
    ProductID INTEGER NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP,
    ListPrice DECIMAL(19,4) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductModel (
    ProductModelID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    CatalogDescription VARCHAR,
    Instructions VARCHAR,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductModelIllustration (
    ProductModelID INTEGER NOT NULL,
    IllustrationID INTEGER NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductModelProductDescriptionCulture (
    ProductModelID INTEGER NOT NULL,
    ProductDescriptionID INTEGER NOT NULL,
    CultureID VARCHAR(6) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductPhoto (
    ProductPhotoID INTEGER NOT NULL,
    ThumbNailPhoto BLOB,
    ThumbnailPhotoFileName VARCHAR(50),
    LargePhoto BLOB,
    LargePhotoFileName VARCHAR(50),
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductProductPhoto (
    ProductID INTEGER NOT NULL,
    ProductPhotoID INTEGER NOT NULL,
    "Primary" BOOLEAN NOT NULL DEFAULT FALSE,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductReview (
    ProductReviewID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    ReviewerName VARCHAR(50) NOT NULL,
    ReviewDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EmailAddress VARCHAR(50) NOT NULL,
    Rating INTEGER NOT NULL,
    Comments VARCHAR,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ProductSubcategory (
    ProductSubcategoryID INTEGER NOT NULL,
    ProductCategoryID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.ScrapReason (
    ScrapReasonID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.TransactionHistory (
    TransactionID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    ReferenceOrderID INTEGER NOT NULL,
    ReferenceOrderLineID INTEGER NOT NULL DEFAULT 0,
    TransactionDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TransactionType VARCHAR(1) NOT NULL,
    Quantity INTEGER NOT NULL,
    ActualCost DECIMAL(19,4) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.TransactionHistoryArchive (
    TransactionID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    ReferenceOrderID INTEGER NOT NULL,
    ReferenceOrderLineID INTEGER NOT NULL DEFAULT 0,
    TransactionDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TransactionType VARCHAR(1) NOT NULL,
    Quantity INTEGER NOT NULL,
    ActualCost DECIMAL(19,4) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.UnitMeasure (
    UnitMeasureCode VARCHAR(3) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.WorkOrder (
    WorkOrderID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    OrderQty INTEGER NOT NULL,
    StockedQty INTEGER NOT NULL,
    ScrappedQty INTEGER NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP,
    DueDate TIMESTAMP NOT NULL,
    ScrapReasonID INTEGER,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS production.WorkOrderRouting (
    WorkOrderID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    OperationSequence INTEGER NOT NULL,
    LocationID INTEGER NOT NULL,
    ScheduledStartDate TIMESTAMP NOT NULL,
    ScheduledEndDate TIMESTAMP NOT NULL,
    ActualStartDate TIMESTAMP,
    ActualEndDate TIMESTAMP,
    ActualResourceHrs DECIMAL(9,4),
    PlannedCost DECIMAL(19,4) NOT NULL,
    ActualCost DECIMAL(19,4),
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Purchasing Schema Tables
-- =============================================

CREATE TABLE IF NOT EXISTS purchasing.ProductVendor (
    ProductID INTEGER NOT NULL,
    BusinessEntityID INTEGER NOT NULL,
    AverageLeadTime INTEGER NOT NULL,
    StandardPrice DECIMAL(19,4) NOT NULL,
    LastReceiptCost DECIMAL(19,4),
    LastReceiptDate TIMESTAMP,
    MinOrderQty INTEGER NOT NULL,
    MaxOrderQty INTEGER NOT NULL,
    OnOrderQty INTEGER,
    UnitMeasureCode VARCHAR(3) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS purchasing.PurchaseOrderDetail (
    PurchaseOrderID INTEGER NOT NULL,
    PurchaseOrderDetailID INTEGER NOT NULL,
    DueDate TIMESTAMP NOT NULL,
    OrderQty INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    UnitPrice DECIMAL(19,4) NOT NULL,
    LineTotal DECIMAL(19,4) NOT NULL,
    ReceivedQty DECIMAL(8,2) NOT NULL,
    RejectedQty DECIMAL(8,2) NOT NULL,
    StockedQty DECIMAL(8,2) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS purchasing.PurchaseOrderHeader (
    PurchaseOrderID INTEGER NOT NULL,
    RevisionNumber INTEGER NOT NULL DEFAULT 0,
    Status INTEGER NOT NULL DEFAULT 1,
    EmployeeID INTEGER NOT NULL,
    VendorID INTEGER NOT NULL,
    ShipMethodID INTEGER NOT NULL,
    OrderDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ShipDate TIMESTAMP,
    SubTotal DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    TaxAmt DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    Freight DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    TotalDue DECIMAL(19,4) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS purchasing.ShipMethod (
    ShipMethodID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ShipBase DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    ShipRate DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS purchasing.Vendor (
    BusinessEntityID INTEGER NOT NULL,
    AccountNumber VARCHAR(15) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    CreditRating INTEGER NOT NULL,
    PreferredVendorStatus BOOLEAN NOT NULL DEFAULT TRUE,
    ActiveFlag BOOLEAN NOT NULL DEFAULT TRUE,
    PurchasingWebServiceURL VARCHAR(1024),
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Sales Schema Tables
-- =============================================

CREATE TABLE IF NOT EXISTS sales.CountryRegionCurrency (
    CountryRegionCode VARCHAR(3) NOT NULL,
    CurrencyCode VARCHAR(3) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.CreditCard (
    CreditCardID INTEGER NOT NULL,
    CardType VARCHAR(50) NOT NULL,
    CardNumber VARCHAR(25) NOT NULL,
    ExpMonth INTEGER NOT NULL,
    ExpYear INTEGER NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.Currency (
    CurrencyCode VARCHAR(3) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.CurrencyRate (
    CurrencyRateID INTEGER NOT NULL,
    CurrencyRateDate TIMESTAMP NOT NULL,
    FromCurrencyCode VARCHAR(3) NOT NULL,
    ToCurrencyCode VARCHAR(3) NOT NULL,
    AverageRate DECIMAL(19,4) NOT NULL,
    EndOfDayRate DECIMAL(19,4) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.Customer (
    CustomerID INTEGER NOT NULL,
    PersonID INTEGER,
    StoreID INTEGER,
    TerritoryID INTEGER,
    AccountNumber VARCHAR(10) NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.PersonCreditCard (
    BusinessEntityID INTEGER NOT NULL,
    CreditCardID INTEGER NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SalesOrderDetail (
    SalesOrderID INTEGER NOT NULL,
    SalesOrderDetailID INTEGER NOT NULL,
    CarrierTrackingNumber VARCHAR(25),
    OrderQty INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    SpecialOfferID INTEGER NOT NULL,
    UnitPrice DECIMAL(19,4) NOT NULL,
    UnitPriceDiscount DECIMAL(19,4) NOT NULL DEFAULT 0.0,
    LineTotal DECIMAL(38,6) NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SalesOrderHeader (
    SalesOrderID INTEGER NOT NULL,
    RevisionNumber INTEGER NOT NULL DEFAULT 0,
    OrderDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DueDate TIMESTAMP NOT NULL,
    ShipDate TIMESTAMP,
    Status INTEGER NOT NULL DEFAULT 1,
    OnlineOrderFlag BOOLEAN NOT NULL DEFAULT TRUE,
    SalesOrderNumber VARCHAR(25) NOT NULL,
    PurchaseOrderNumber VARCHAR(25),
    AccountNumber VARCHAR(15),
    CustomerID INTEGER NOT NULL,
    SalesPersonID INTEGER,
    TerritoryID INTEGER,
    BillToAddressID INTEGER NOT NULL,
    ShipToAddressID INTEGER NOT NULL,
    ShipMethodID INTEGER NOT NULL,
    CreditCardID INTEGER,
    CreditCardApprovalCode VARCHAR(15),
    CurrencyRateID INTEGER,
    SubTotal DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    TaxAmt DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    Freight DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    TotalDue DECIMAL(19,4) NOT NULL,
    Comment VARCHAR(128),
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SalesOrderHeaderSalesReason (
    SalesOrderID INTEGER NOT NULL,
    SalesReasonID INTEGER NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SalesPerson (
    BusinessEntityID INTEGER NOT NULL,
    TerritoryID INTEGER,
    SalesQuota DECIMAL(19,4),
    Bonus DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    CommissionPct DECIMAL(10,4) NOT NULL DEFAULT 0.00,
    SalesYTD DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    SalesLastYear DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SalesPersonQuotaHistory (
    BusinessEntityID INTEGER NOT NULL,
    QuotaDate TIMESTAMP NOT NULL,
    SalesQuota DECIMAL(19,4) NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SalesReason (
    SalesReasonID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ReasonType VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SalesTaxRate (
    SalesTaxRateID INTEGER NOT NULL,
    StateProvinceID INTEGER NOT NULL,
    TaxType INTEGER NOT NULL,
    TaxRate DECIMAL(10,4) NOT NULL DEFAULT 0.00,
    Name VARCHAR(50) NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SalesTerritory (
    TerritoryID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    CountryRegionCode VARCHAR(3) NOT NULL,
    "Group" VARCHAR(50) NOT NULL,
    SalesYTD DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    SalesLastYear DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    CostYTD DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    CostLastYear DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SalesTerritoryHistory (
    BusinessEntityID INTEGER NOT NULL,
    TerritoryID INTEGER NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.ShoppingCartItem (
    ShoppingCartItemID INTEGER NOT NULL,
    ShoppingCartID VARCHAR(50) NOT NULL,
    Quantity INTEGER NOT NULL DEFAULT 1,
    ProductID INTEGER NOT NULL,
    DateCreated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SpecialOffer (
    SpecialOfferID INTEGER NOT NULL,
    Description VARCHAR(255) NOT NULL,
    DiscountPct DECIMAL(10,4) NOT NULL DEFAULT 0.00,
    Type VARCHAR(50) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NOT NULL,
    MinQty INTEGER NOT NULL DEFAULT 0,
    MaxQty INTEGER,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.SpecialOfferProduct (
    SpecialOfferID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.Store (
    BusinessEntityID INTEGER NOT NULL,
    Name VARCHAR(50) NOT NULL,
    SalesPersonID INTEGER,
    Demographics VARCHAR,
    rowguid VARCHAR(36) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
