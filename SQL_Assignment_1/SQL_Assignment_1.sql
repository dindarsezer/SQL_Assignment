CREATE DATABASE Manufacturer;

USE Manufacturer;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    QuantityOnHand INT NOT NULL
);

CREATE TABLE Components (
    ComponentID INT PRIMARY KEY,
    ComponentName VARCHAR(255) NOT NULL,
    Description TEXT,
    QuantityOnHand INT NOT NULL
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,
    ActivationStatus BIT NOT NULL
);

CREATE TABLE ComponentSuppliers (
    ComponentID INT,
    SupplierID INT,
    SupplyDate DATE,
    QuantitySupplied INT,
	PRIMARY KEY (ComponentID, SupplierID),
    FOREIGN KEY (ComponentID) REFERENCES Components(ComponentID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE ProductComponents (
    ProductID INT,
    ComponentID INT,
	PRIMARY KEY (ProductID, ComponentID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (ComponentID) REFERENCES Components(ComponentID)
);
