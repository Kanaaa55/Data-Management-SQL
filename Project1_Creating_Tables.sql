DROP DATABASE IF EXISTS Textbooks;
CREATE DATABASE Textbooks;
USE Textbooks;

# AUTHOR Table
CREATE TABLE Author (
	AuthorID INT,
	AuthorFirstName VARCHAR(50),
	AuthorLastName VARCHAR(50),
    
	PRIMARY KEY (AuthorID)
);

# BOOK Table
CREATE TABLE Book (
	BookID INT,
	EditionNumber INT,
	Title VARCHAR(100),
    Price INT,

	PRIMARY KEY (BookID, EditionNumber)
);

# Subject Table
CREATE TABLE `Subject` (
    SubjectID INT PRIMARY KEY,
    SubjectName VARCHAR(50) UNIQUE
);

# Book Subjects Junction Table
CREATE TABLE BookSubject (
    BookID INT,
	EditionNumber INT,
    SubjectID INT,
    PRIMARY KEY (BookID, EditionNumber, SubjectID),
	FOREIGN KEY (BookID, EditionNumber) REFERENCES Book(BookID, EditionNumber),
    FOREIGN KEY (SubjectID) REFERENCES `Subject`(SubjectID)
);

-- Subtype table for PAPER books
CREATE TABLE Paper (
    BookID INT,
    EditionNumber INT,
    
	PRIMARY KEY (BookID, EditionNumber),
    
    FOREIGN KEY (BookID, EditionNumber) REFERENCES Book(BookID, EditionNumber)
);

-- Subtype table for EBOOK books
CREATE TABLE Ebook (
    BookID INT,
    EditionNumber INT,
    -- Additional attributes specific to Ebooks
    LicenseID INT,
        
    PRIMARY KEY (BookID, EditionNumber),
    FOREIGN KEY (BookID, EditionNumber) REFERENCES Book(BookID, EditionNumber)
    
);

# CUSTOMER table
CREATE TABLE Customer (
	CustomerID INT PRIMARY KEY
);

# PaymentMethod Table
CREATE TABLE PaymentMethod (
	PaymentID INT PRIMARY KEY,
    PaymentType VARCHAR(50),
    BillingStreet VARCHAR(100), -- Billing address: Street
    BillingState VARCHAR(50),   -- Billing address: State
    BillingZip VARCHAR(20),     -- Billing address: Zip code
    ShippingStreet VARCHAR(100), -- Shipping address: Street
    ShippingState VARCHAR(50),   -- Shipping address: State
    ShippingZip VARCHAR(20)      -- Shipping address: Zip code
);

# PaymentMethod Customer Junction Table
CREATE TABLE CustomerPaymentMethod (
    CustomerID INT,
	PaymentID INT,
    PRIMARY KEY (CustomerID, PaymentID),
	
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (PaymentID) REFERENCES PaymentMethod(PaymentID)
);


-- Subtype table for INSTITUTION customer
CREATE TABLE Institution (
    CustomerID INT PRIMARY KEY,
    -- Additional attributes specific to mammals
    InstitutionID INT,
    InstitutionName VARCHAR(100),
    
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID)
);

-- Subtype table for INDIVIDUAL customer
CREATE TABLE Individual (
    CustomerID INT PRIMARY KEY,
    -- Additional attributes specific to mammals
    IndividualID INT,
    IndividualFirstName VARCHAR(100),
    IndividualLastName VARCHAR(100),
    
    FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID)
);

# ORDER Table
CREATE TABLE `Order` (
    OrderID INT PRIMARY KEY,
	OrderDate DATE,

    CustomerID INT, -- b/c 1:M relationship w Customer
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);


# STUDENT ACCOUNT table
CREATE TABLE StudentAccount (
    StudentAccountNumber INT PRIMARY KEY,
    StudentAccountFirstName VARCHAR(50),
    StudentAccountLastName VARCHAR(50),
    StudentAccountUsername VARCHAR(50),
    StudentAccountPassword VARCHAR(50),
    
    -- b/c 1:M for StudentAccount w/ Customer
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);



# EMPLOYEE table
CREATE TABLE Employee (
	EmployeeID INT PRIMARY KEY,
	EmployeeFirstName VARCHAR(100),
	EmployeeLastName VARCHAR(100),
    AnnualSalary INT
);

-- Subtype table for OFFICE employee
CREATE TABLE Office (
    EmployeeID INT PRIMARY KEY,
    -- Additional attributes specific to Office employees
    OfficeID INT,
    
    FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID)
);


-- Subtype table for VIDEO TUTOR employee
CREATE TABLE VideoTutor (
    EmployeeID INT PRIMARY KEY,
    -- Additional attributes specific to Video Tutors
    VideoTutorID INT,
    
    FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID)
);

# DEPARTMENT table
CREATE TABLE Department (
	DepartmentID INT PRIMARY KEY,
	DepartmentName VARCHAR(100)
);


# VIDEO TUTOR SUBJECT table
CREATE TABLE VideoTutorSubject (
	VideoTutorSubjectID INT PRIMARY KEY,
	VideoTutorSubjectName VARCHAR(100)
);


-- Junction table for the many-to-many relationship b/w Book and Author
CREATE TABLE AuthorBook (
    AuthorID INT,
    BookID INT,
    EditionNumber INT,
    PRIMARY KEY (AuthorID, BookID, EditionNumber),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (BookID, EditionNumber) REFERENCES Book(BookID, EditionNumber)
);

-- JUNCTION TABLE for the many-to-many relationship b/w Book and Order
CREATE TABLE BookOrder (
    BookID INT,
    EditionNumber INT,
    OrderID INT,
    Quantity INT,
    PRIMARY KEY (BookID, EditionNumber, OrderID),
    FOREIGN KEY (BookID, EditionNumber) REFERENCES Book(BookID, EditionNumber),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID)
);


-- JUNCTION TABLE for the many-to-many relationship b/w Order and Employee
CREATE TABLE OrderEmployee (
    OrderID INT,
    EmployeeID INT,
    PRIMARY KEY (OrderID, EmployeeID),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);



-- JUNCTION TABLE for the many-to-many relationship b/w VideoTutor and VideoTutorSubject
CREATE TABLE VideoTutorVideoTutorSubject (
    EmployeeID INT,
    VideoTutorSubjectID INT,
    PRIMARY KEY (EmployeeID, VideoTutorSubjectID),
    FOREIGN KEY (EmployeeID) REFERENCES VideoTutor (EmployeeID),
    FOREIGN KEY (VideoTutorSubjectID) REFERENCES VideoTutorSubject (VideoTutorSubjectID)
);


-- Junction table for the many-to-many relationship b/w Office employees and Department
CREATE TABLE OfficeDepartment (
    EmployeeID INT,
    DepartmentID INT,
    PRIMARY KEY (EmployeeID, DepartmentID),
    FOREIGN KEY (EmployeeID) REFERENCES Office (EmployeeID),
    FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID)
);

-- Junction table for the many-to-many relationship b/w VideoTutorSubject and Ebook
CREATE TABLE EbookVideoTutorSubject (
    BookID INT,
    EditionNumber INT,
    VideoTutorSubjectID INT,
    PRIMARY KEY (BookID, EditionNumber, VideoTutorSubjectID),
    FOREIGN KEY (BookID, EditionNumber) REFERENCES Ebook(BookID, EditionNumber),
    FOREIGN KEY (VideoTutorSubjectID) REFERENCES VideoTutorSubject(VideoTutorSubjectID)
);

-- JUNCTION TABLE for the many-to-many relationship b/w StudentAccount and Ebook
CREATE TABLE StudentEbook (
    StudentAccountNumber INT,
    BookID INT,
    EditionNumber INT,
    PRIMARY KEY (StudentAccountNumber, BookID, EditionNumber),
    FOREIGN KEY (StudentAccountNumber) REFERENCES StudentAccount(StudentAccountNumber),
    FOREIGN KEY (BookID, EditionNumber) REFERENCES Ebook(BookID, EditionNumber)
);
