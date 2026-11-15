-- 03_load_data.sql
-- Purpose: Load AdventureWorks OLTP CSV data into DuckDB tables
-- Note: Paths are relative to database directory (or parameterized by build script)

-- Person schema
COPY person.Address FROM 'data/Address.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.AddressType FROM 'data/AddressType.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.BusinessEntity FROM 'data/BusinessEntity.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.BusinessEntityAddress FROM 'data/BusinessEntityAddress.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.BusinessEntityContact FROM 'data/BusinessEntityContact.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.ContactType FROM 'data/ContactType.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.CountryRegion FROM 'data/CountryRegion.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.EmailAddress FROM 'data/EmailAddress.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.Password FROM 'data/Password.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.Person FROM 'data/Person.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.PersonPhone FROM 'data/PersonPhone.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.PhoneNumberType FROM 'data/PhoneNumberType.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY person.StateProvince FROM 'data/StateProvince.csv' (DELIMITER '\t', HEADER false, NULL '');

-- HumanResources schema
COPY humanresources.Department FROM 'data/Department.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY humanresources.Employee FROM 'data/Employee.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY humanresources.EmployeeDepartmentHistory FROM 'data/EmployeeDepartmentHistory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY humanresources.EmployeePayHistory FROM 'data/EmployeePayHistory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY humanresources.JobCandidate FROM 'data/JobCandidate.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY humanresources.Shift FROM 'data/Shift.csv' (DELIMITER '\t', HEADER false, NULL '');

-- Production schema
COPY production.BillOfMaterials FROM 'data/BillOfMaterials.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.Culture FROM 'data/Culture.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.Document FROM 'data/Document.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.Illustration FROM 'data/Illustration.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.Location FROM 'data/Location.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.Product FROM 'data/Product.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductCategory FROM 'data/ProductCategory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductCostHistory FROM 'data/ProductCostHistory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductDescription FROM 'data/ProductDescription.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductDocument FROM 'data/ProductDocument.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductInventory FROM 'data/ProductInventory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductListPriceHistory FROM 'data/ProductListPriceHistory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductModel FROM 'data/ProductModel.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductModelIllustration FROM 'data/ProductModelIllustration.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductModelProductDescriptionCulture FROM 'data/ProductModelProductDescriptionCulture.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductPhoto FROM 'data/ProductPhoto.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductProductPhoto FROM 'data/ProductProductPhoto.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductReview FROM 'data/ProductReview.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ProductSubcategory FROM 'data/ProductSubcategory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.ScrapReason FROM 'data/ScrapReason.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.TransactionHistory FROM 'data/TransactionHistory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.TransactionHistoryArchive FROM 'data/TransactionHistoryArchive.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.UnitMeasure FROM 'data/UnitMeasure.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.WorkOrder FROM 'data/WorkOrder.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY production.WorkOrderRouting FROM 'data/WorkOrderRouting.csv' (DELIMITER '\t', HEADER false, NULL '');

-- Purchasing schema
COPY purchasing.ProductVendor FROM 'data/ProductVendor.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY purchasing.PurchaseOrderDetail FROM 'data/PurchaseOrderDetail.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY purchasing.PurchaseOrderHeader FROM 'data/PurchaseOrderHeader.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY purchasing.ShipMethod FROM 'data/ShipMethod.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY purchasing.Vendor FROM 'data/Vendor.csv' (DELIMITER '\t', HEADER false, NULL '');

-- Sales schema
COPY sales.CountryRegionCurrency FROM 'data/CountryRegionCurrency.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.CreditCard FROM 'data/CreditCard.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.Currency FROM 'data/Currency.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.CurrencyRate FROM 'data/CurrencyRate.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.Customer FROM 'data/Customer.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.PersonCreditCard FROM 'data/PersonCreditCard.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SalesOrderDetail FROM 'data/SalesOrderDetail.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SalesOrderHeader FROM 'data/SalesOrderHeader.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SalesOrderHeaderSalesReason FROM 'data/SalesOrderHeaderSalesReason.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SalesPerson FROM 'data/SalesPerson.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SalesPersonQuotaHistory FROM 'data/SalesPersonQuotaHistory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SalesReason FROM 'data/SalesReason.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SalesTaxRate FROM 'data/SalesTaxRate.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SalesTerritory FROM 'data/SalesTerritory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SalesTerritoryHistory FROM 'data/SalesTerritoryHistory.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.ShoppingCartItem FROM 'data/ShoppingCartItem.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SpecialOffer FROM 'data/SpecialOffer.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.SpecialOfferProduct FROM 'data/SpecialOfferProduct.csv' (DELIMITER '\t', HEADER false, NULL '');
COPY sales.Store FROM 'data/Store.csv' (DELIMITER '\t', HEADER false, NULL '');
