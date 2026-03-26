-- ============================================
-- BankDB - FIXED SCRIPT
-- Fixes applied:
--   1. Removed stray 'users' keyword
--   2. Added CREATE USER BranchManager_Michael
--   3. Fixed role name BranchManagers -> BranchManager
--   4. Removed duplicate ALTER TABLE ADD PRIMARY KEY
--   5. Renamed PaymentID -> LoanID in Loans.Payments
--   6. Added GO between Compliance and HR schemas
--   7. Added FOREIGN KEY constraints
--   8. Fixed TrandDate typo -> TransactionDate
-- ============================================

CREATE DATABASE BankDB;
GO

USE BankDB;
GO

CREATE SCHEMA Accounts;
GO

CREATE SCHEMA Loans;
GO

CREATE SCHEMA Compliance;
GO

-- FIX 6: Added missing GO before HR schema
CREATE SCHEMA HR;
GO

-- ============================================
-- TABLES
-- ============================================

CREATE TABLE Accounts.Customers (
    CustomerID  INT          PRIMARY KEY,
    Name        VARCHAR(100),
    SSN         CHAR(11),
    Address     VARCHAR(255)
);

CREATE TABLE Accounts.Accounts (
    AccountsID  INT          PRIMARY KEY,
    CustomerID  INT,
    Balance     DECIMAL(15,2),
    AccountType VARCHAR(50),
    -- FIX 7: Added foreign key constraint
    CONSTRAINT FK_Accounts_Customer FOREIGN KEY (CustomerID)
        REFERENCES Accounts.Customers(CustomerID)
);

-- FIX 8: Renamed TrandDate -> TransactionDate
CREATE TABLE Accounts.Transactions (
    TransactionID   INT          PRIMARY KEY,
    AccountID       INT,
    Amount          DECIMAL(15,2),
    TransactionDate DATETIME,
    -- FIX 7: Added foreign key constraint
    CONSTRAINT FK_Transactions_Account FOREIGN KEY (AccountID)
        REFERENCES Accounts.Accounts(AccountsID)
);

CREATE TABLE Loans.Loans (
    LoanID       INT          PRIMARY KEY,
    CustomerID   INT,
    Amount       DECIMAL(15,2),
    InterestRate DECIMAL(5,2),
    -- FIX 7: Added foreign key constraint
    CONSTRAINT FK_Loans_Customer FOREIGN KEY (CustomerID)
        REFERENCES Accounts.Customers(CustomerID)
);

-- FIX 5: Renamed PaymentID -> LoanID; added foreign key
CREATE TABLE Loans.Payments (
    LoanPayment INT          PRIMARY KEY,
    LoanID      INT,
    Amount      DECIMAL(15,2),
    DueDate     DATE,
    Paid        BIT,
    CONSTRAINT FK_Payments_Loan FOREIGN KEY (LoanID)
        REFERENCES Loans.Loans(LoanID)
);

CREATE TABLE Compliance.AuditLog (
    LogID           INT          PRIMARY KEY,
    Username        VARCHAR(100),
    ActionPerformed VARCHAR(255),
    TableAffected   VARCHAR(100),
    ActionDate      DATETIME
);

CREATE TABLE HR.Employees (
    EmployeeID INT          PRIMARY KEY,
    Name       VARCHAR(100),
    Position   VARCHAR(50),
    Salary     DECIMAL(15,2)
);
GO

-- ============================================
-- USERS
-- FIX 1: Removed stray 'users' keyword
-- FIX 2: Added missing BranchManager_Michael user
-- ============================================

CREATE USER Teller_Kevin         WITHOUT LOGIN;
CREATE USER LoanOfficer_Pam      WITHOUT LOGIN;
CREATE USER Compliance_Oscar     WITHOUT LOGIN;
CREATE USER BranchManager_Michael WITHOUT LOGIN;  -- FIX 2
CREATE USER HR_Toby              WITHOUT LOGIN;
GO

-- ============================================
-- ROLES
-- ============================================

CREATE ROLE Tellers;
CREATE ROLE LoanOfficers;
CREATE ROLE ComplianceOfficers;
CREATE ROLE BranchManager;
CREATE ROLE HRStaff;
GO

-- ============================================
-- ASSIGN USERS TO ROLES
-- FIX 3: Changed 'BranchManagers' -> 'BranchManager'
-- ============================================

EXEC sp_addrolemember 'Tellers',            'Teller_Kevin';
EXEC sp_addrolemember 'LoanOfficers',       'LoanOfficer_Pam';
EXEC sp_addrolemember 'ComplianceOfficers', 'Compliance_Oscar';
EXEC sp_addrolemember 'BranchManager',      'BranchManager_Michael';  -- FIX 3
EXEC sp_addrolemember 'HRStaff',            'HR_Toby';

-- Managers can also act as Loan Officers and Tellers
EXEC sp_addrolemember 'LoanOfficers', 'BranchManager_Michael';
EXEC sp_addrolemember 'Tellers',      'BranchManager_Michael';
GO

-- ============================================
-- DATA: Accounts.Customers
-- FIX 4: Removed duplicate ALTER TABLE ADD PRIMARY KEY
-- ============================================

INSERT INTO Accounts.Customers (CustomerID, Name, SSN, Address)
VALUES
(1, 'John Casinillo',      '123-45-6789', '742 Evergreen St Springfield'),
(2, 'Maria Garcia',        '234-56-7890', '120 Maple Ave Los Angeles'),
(3, 'David Johnson',       '345-67-8901', '55 Oak Street Chicago'),
(4, 'Sarah Brown',         '456-78-9012', '89 Pine Lane Houston'),
(5, 'Michael Davis',       '567-89-0123', '210 Cedar Rd Phoenix'),
(6, 'Emma Wilson',         '678-90-1234', '14 Birch Blvd Dallas'),
(7, 'Daniel Taylor',       '789-01-2345', '67 Palm St Miami'),
(8, 'Olivia Anderson',     '890-12-3456', '98 Lake View Dr Seattle'),
(9, 'James Thomas',        '901-23-4567', '33 River Rd Boston'),
(10,'Sophia Martinez',     '112-34-5678', '777 Sunset Blvd San Diego'),
(11,'William Hernandez',   '223-45-6789', '19 Park Ave San Jose'),
(12,'Isabella Lopez',      '334-56-7890', '54 Willow St Austin'),
(13,'Benjamin Gonzalez',   '445-67-8901', '88 Hill Rd Denver'),
(14,'Mia Perez',           '556-78-9012', '100 Peachtree St Atlanta'),
(15,'Lucas Sanchez',       '667-89-0123', '12 Orange Dr Orlando'),
(16,'Charlotte Clark',     '778-90-1234', '76 Bay St Tampa'),
(17,'Henry Ramirez',       '889-01-2345', '25 Wood St Detroit'),
(18,'Amelia Lewis',        '990-12-3456', '59 Garden Rd Portland'),
(19,'Alexander Lee',       '101-23-4567', '44 Desert Ln Las Vegas'),
(20,'Harper Walker',       '202-34-5678', '18 Snow St Minneapolis'),
(21,'Ethan Hall',          '303-45-6789', '92 Lake St Cleveland'),
(22,'Evelyn Allen',        '404-56-7890', '66 Broad St Columbus'),
(23,'Mason Young',         '505-67-8901', '13 Queen St Charlotte'),
(24,'Abigail King',        '606-78-9012', '72 King Rd Indianapolis'),
(25,'Logan Wright',        '707-89-0123', '21 Mission St San Antonio'),
(26,'Ella Scott',          '808-90-1234', '63 Music Row Nashville'),
(27,'Jacob Green',         '909-01-2345', '7 Market St Kansas City'),
(28,'Avery Baker',         '111-22-3333', '90 Capitol Ave Sacramento'),
(29,'Sebastian Adams',     '222-33-4444', '52 Olive St Fresno'),
(30,'Scarlett Nelson',     '333-44-5555', '34 Mesa Dr Mesa'),
(31,'Jack Hill',           '444-55-6666', '81 Prairie Ave Omaha'),
(32,'Victoria Rivera',     '555-66-7777', '29 Tulsa Rd Tulsa'),
(33,'Owen Campbell',       '666-77-8888', '10 Center St Arlington'),
(34,'Luna Mitchell',       '777-88-9999', '75 Aurora Ln Aurora'),
(35,'Wyatt Carter',        '888-99-0000', '61 Steel St Pittsburgh'),
(36,'Chloe Roberts',       '999-00-1111', '28 Vine St Cincinnati'),
(37,'Luke Gomez',          '121-21-2121', '49 Glacier Rd Anchorage'),
(38,'Grace Phillips',      '232-32-3232', '93 Liberty St Newark'),
(39,'Gabriel Evans',       '343-43-4343', '56 Harbor Rd Toledo'),
(40,'Lily Turner',         '454-54-5454', '14 Lake Mendota Dr Madison'),
(41,'Carter Diaz',         '565-65-6565', '77 Sierra Rd Reno'),
(42,'Aria Parker',         '676-76-7676', '25 Niagara St Buffalo'),
(43,'Julian Cruz',         '787-87-8787', '11 Riverfront Dr Spokane'),
(44,'Zoe Edwards',         '898-98-9898', '90 Tacoma Ave Tacoma'),
(45,'Leo Collins',         '909-09-9090', '65 Irving Park Rd Irving'),
(46,'Nora Stewart',        '212-12-1212', '33 Border St Laredo'),
(47,'Isaac Morris',        '323-23-2323', '48 Garland Ave Garland'),
(48,'Hannah Rogers',       '434-34-3434', '74 Glendale Blvd Glendale'),
(49,'Caleb Reed',          '545-45-4545', '15 Palm Ave Hialeah'),
(50,'Stella Cook',         '656-56-5656', '62 Bayview Rd Chesapeake');

SELECT * FROM Accounts.Customers;

-- ============================================
-- DATA: Accounts.Accounts
-- ============================================

INSERT INTO Accounts.Accounts (AccountsID, CustomerID, Balance, AccountType)
VALUES
(1001,1,5200,'Savings'),
(1002,2,12400,'Checking'),
(1003,3,8300,'Savings'),
(1004,4,15000,'Checking'),
(1005,5,6200,'Savings'),
(1006,6,9100,'Savings'),
(1007,7,11000,'Checking'),
(1008,8,7600,'Savings'),
(1009,9,13200,'Checking'),
(1010,10,5400,'Savings'),
(1011,11,14800,'Checking'),
(1012,12,7200,'Savings'),
(1013,13,9800,'Checking'),
(1014,14,6100,'Savings'),
(1015,15,13400,'Checking'),
(1016,16,8700,'Savings'),
(1017,17,9500,'Checking'),
(1018,18,6900,'Savings'),
(1019,19,14300,'Checking'),
(1020,20,5800,'Savings'),
(1021,21,10100,'Checking'),
(1022,22,7400,'Savings'),
(1023,23,11800,'Checking'),
(1024,24,6600,'Savings'),
(1025,25,9200,'Checking'),
(1026,26,7100,'Savings'),
(1027,27,12000,'Checking'),
(1028,28,6300,'Savings'),
(1029,29,14000,'Checking'),
(1030,30,5600,'Savings'),
(1031,31,9900,'Checking'),
(1032,32,8200,'Savings'),
(1033,33,10700,'Checking'),
(1034,34,5900,'Savings'),
(1035,35,11300,'Checking'),
(1036,36,6800,'Savings'),
(1037,37,12100,'Checking'),
(1038,38,7500,'Savings'),
(1039,39,8800,'Checking'),
(1040,40,6400,'Savings'),
(1041,41,9700,'Checking'),
(1042,42,5300,'Savings'),
(1043,43,14200,'Checking'),
(1044,44,6100,'Savings'),
(1045,45,10800,'Checking'),
(1046,46,7200,'Savings'),
(1047,47,9900,'Checking'),
(1048,48,6500,'Savings'),
(1049,49,13700,'Checking'),
(1050,50,7000,'Savings');

SELECT * FROM Accounts.Accounts;

-- ============================================
-- DATA: Accounts.Transactions
-- FIX 8: Column renamed to TransactionDate
-- ============================================

INSERT INTO Accounts.Transactions (TransactionID, AccountID, Amount, TransactionDate)
VALUES
(2001,1001,500,'2026-01-05'),
(2002,1002,1200,'2026-01-06'),
(2003,1003,300,'2026-01-07'),
(2004,1004,1500,'2026-01-08'),
(2005,1005,450,'2026-01-09'),
(2006,1006,700,'2026-01-10'),
(2007,1007,900,'2026-01-11'),
(2008,1008,250,'2026-01-12'),
(2009,1009,1100,'2026-01-13'),
(2010,1010,350,'2026-01-14'),
(2011,1011,2000,'2026-01-15'),
(2012,1012,600,'2026-01-16'),
(2013,1013,750,'2026-01-17'),
(2014,1014,400,'2026-01-18'),
(2015,1015,1300,'2026-01-19'),
(2016,1016,500,'2026-01-20'),
(2017,1017,800,'2026-01-21'),
(2018,1018,320,'2026-01-22'),
(2019,1019,1700,'2026-01-23'),
(2020,1020,290,'2026-01-24'),
(2021,1021,950,'2026-01-25'),
(2022,1022,410,'2026-01-26'),
(2023,1023,1000,'2026-01-27'),
(2024,1024,380,'2026-01-28'),
(2025,1025,720,'2026-01-29'),
(2026,1026,450,'2026-01-30'),
(2027,1027,1250,'2026-02-01'),
(2028,1028,360,'2026-02-02'),
(2029,1029,1800,'2026-02-03'),
(2030,1030,275,'2026-02-04'),
(2031,1031,840,'2026-02-05'),
(2032,1032,500,'2026-02-06'),
(2033,1033,920,'2026-02-07'),
(2034,1034,310,'2026-02-08'),
(2035,1035,1100,'2026-02-09'),
(2036,1036,430,'2026-02-10'),
(2037,1037,990,'2026-02-11'),
(2038,1038,520,'2026-02-12'),
(2039,1039,760,'2026-02-13'),
(2040,1040,340,'2026-02-14'),
(2041,1041,870,'2026-02-15'),
(2042,1042,260,'2026-02-16'),
(2043,1043,1500,'2026-02-17'),
(2044,1044,390,'2026-02-18'),
(2045,1045,980,'2026-02-19'),
(2046,1046,450,'2026-02-20'),
(2047,1047,910,'2026-02-21'),
(2048,1048,370,'2026-02-22'),
(2049,1049,1400,'2026-02-23'),
(2050,1050,420,'2026-02-24');

SELECT * FROM Accounts.Transactions;

-- ============================================
-- DATA: Loans.Loans
-- ============================================

INSERT INTO Loans.Loans (LoanID, CustomerID, Amount, InterestRate)
VALUES
(3001,1,10000,5.5),
(3002,2,15000,6.0),
(3003,3,8000,5.2),
(3004,4,20000,6.5),
(3005,5,12000,5.8),
(3006,6,9000,5.4),
(3007,7,18000,6.3),
(3008,8,7500,5.1),
(3009,9,16000,6.0),
(3010,10,7000,5.0),
(3011,11,22000,6.7),
(3012,12,8500,5.3),
(3013,13,14000,5.9),
(3014,14,6000,4.9),
(3015,15,17000,6.2),
(3016,16,9500,5.4),
(3017,17,13000,5.7),
(3018,18,7200,5.0),
(3019,19,21000,6.6),
(3020,20,6800,4.8),
(3021,21,15000,6.1),
(3022,22,8800,5.2),
(3023,23,12500,5.6),
(3024,24,7700,5.1),
(3025,25,14500,5.9),
(3026,26,8200,5.3),
(3027,27,19000,6.4),
(3028,28,6900,4.9),
(3029,29,23000,6.8),
(3030,30,6400,4.7),
(3031,31,13500,5.8),
(3032,32,9100,5.2),
(3033,33,15500,6.0),
(3034,34,7300,5.0),
(3035,35,16500,6.1),
(3036,36,8400,5.3),
(3037,37,17500,6.2),
(3038,38,9200,5.4),
(3039,39,14000,5.7),
(3040,40,7600,5.1),
(3041,41,15000,5.9),
(3042,42,6800,4.8),
(3043,43,21000,6.5),
(3044,44,7200,5.0),
(3045,45,16000,6.1),
(3046,46,8300,5.2),
(3047,47,14500,5.8),
(3048,48,7900,5.1),
(3049,49,20000,6.4),
(3050,50,8700,5.3);

SELECT * FROM Loans.Loans;

-- ============================================
-- DATA: Loans.Payments
-- FIX 5: Column PaymentID renamed to LoanID
-- ============================================

INSERT INTO Loans.Payments (LoanPayment, LoanID, Amount, DueDate, Paid)
VALUES
(4001,3001,500,'2026-03-01',1),
(4002,3002,650,'2026-03-02',0),
(4003,3003,400,'2026-03-03',1),
(4004,3004,800,'2026-03-04',0),
(4005,3005,550,'2026-03-05',1),
(4006,3006,450,'2026-03-06',1),
(4007,3007,700,'2026-03-07',0),
(4008,3008,380,'2026-03-08',1),
(4009,3009,720,'2026-03-09',0),
(4010,3010,350,'2026-03-10',1),
(4011,3011,900,'2026-03-11',0),
(4012,3012,420,'2026-03-12',1),
(4013,3013,610,'2026-03-13',0),
(4014,3014,300,'2026-03-14',1),
(4015,3015,760,'2026-03-15',0),
(4016,3016,470,'2026-03-16',1),
(4017,3017,580,'2026-03-17',0),
(4018,3018,360,'2026-03-18',1),
(4019,3019,880,'2026-03-19',0),
(4020,3020,330,'2026-03-20',1),
(4021,3021,640,'2026-03-21',0),
(4022,3022,410,'2026-03-22',1),
(4023,3023,520,'2026-03-23',0),
(4024,3024,370,'2026-03-24',1),
(4025,3025,660,'2026-03-25',0),
(4026,3026,430,'2026-03-26',1),
(4027,3027,790,'2026-03-27',0),
(4028,3028,340,'2026-03-28',1),
(4029,3029,920,'2026-03-29',0),
(4030,3030,310,'2026-03-30',1),
(4031,3031,600,'2026-03-31',0),
(4032,3032,450,'2026-04-01',1),
(4033,3033,680,'2026-04-02',0),
(4034,3034,390,'2026-04-03',1),
(4035,3035,720,'2026-04-04',0),
(4036,3036,420,'2026-04-05',1),
(4037,3037,750,'2026-04-06',0),
(4038,3038,460,'2026-04-07',1),
(4039,3039,590,'2026-04-08',0),
(4040,3040,370,'2026-04-09',1),
(4041,3041,610,'2026-04-10',0),
(4042,3042,330,'2026-04-11',1),
(4043,3043,850,'2026-04-12',0),
(4044,3044,360,'2026-04-13',1),
(4045,3045,700,'2026-04-14',0),
(4046,3046,440,'2026-04-15',1),
(4047,3047,630,'2026-04-16',0),
(4048,3048,380,'2026-04-17',1),
(4049,3049,810,'2026-04-18',0),
(4050,3050,450,'2026-04-19',1);

SELECT * FROM Loans.Payments;

-- ============================================
-- DATA: Compliance.AuditLog
-- ============================================

INSERT INTO Compliance.AuditLog (LogID, Username, ActionPerformed, TableAffected, ActionDate)
VALUES
(5001,'admin','INSERT','Customers','2026-01-05'),
(5002,'admin','INSERT','Accounts','2026-01-05'),
(5003,'system','INSERT','Transactions','2026-01-06'),
(5004,'admin','UPDATE','Accounts','2026-01-07'),
(5005,'manager','INSERT','Loans','2026-01-08'),
(5006,'system','INSERT','Transactions','2026-01-09'),
(5007,'admin','UPDATE','Customers','2026-01-10'),
(5008,'auditor','SELECT','Transactions','2026-01-11'),
(5009,'admin','UPDATE','Accounts','2026-01-12'),
(5010,'system','INSERT','Transactions','2026-01-13'),
(5011,'manager','UPDATE','Loans','2026-01-14'),
(5012,'admin','DELETE','Transactions','2026-01-15'),
(5013,'system','INSERT','Transactions','2026-01-16'),
(5014,'admin','UPDATE','Accounts','2026-01-17'),
(5015,'auditor','SELECT','Customers','2026-01-18'),
(5016,'system','INSERT','Transactions','2026-01-19'),
(5017,'admin','UPDATE','Customers','2026-01-20'),
(5018,'manager','INSERT','Loans','2026-01-21'),
(5019,'system','INSERT','Transactions','2026-01-22'),
(5020,'admin','UPDATE','Accounts','2026-01-23'),
(5021,'auditor','SELECT','Accounts','2026-01-24'),
(5022,'system','INSERT','Transactions','2026-01-25'),
(5023,'admin','UPDATE','Customers','2026-01-26'),
(5024,'manager','UPDATE','Loans','2026-01-27'),
(5025,'system','INSERT','Transactions','2026-01-28'),
(5026,'admin','UPDATE','Accounts','2026-01-29'),
(5027,'auditor','SELECT','Transactions','2026-01-30'),
(5028,'system','INSERT','Transactions','2026-02-01'),
(5029,'admin','UPDATE','Customers','2026-02-02'),
(5030,'manager','INSERT','Loans','2026-02-03'),
(5031,'system','INSERT','Transactions','2026-02-04'),
(5032,'admin','UPDATE','Accounts','2026-02-05'),
(5033,'auditor','SELECT','Loans','2026-02-06'),
(5034,'system','INSERT','Transactions','2026-02-07'),
(5035,'admin','UPDATE','Customers','2026-02-08'),
(5036,'manager','UPDATE','Loans','2026-02-09'),
(5037,'system','INSERT','Transactions','2026-02-10'),
(5038,'admin','UPDATE','Accounts','2026-02-11'),
(5039,'auditor','SELECT','Customers','2026-02-12'),
(5040,'system','INSERT','Transactions','2026-02-13'),
(5041,'admin','UPDATE','Customers','2026-02-14'),
(5042,'manager','INSERT','Loans','2026-02-15'),
(5043,'system','INSERT','Transactions','2026-02-16'),
(5044,'admin','UPDATE','Accounts','2026-02-17'),
(5045,'auditor','SELECT','Transactions','2026-02-18'),
(5046,'system','INSERT','Transactions','2026-02-19'),
(5047,'admin','UPDATE','Customers','2026-02-20'),
(5048,'manager','UPDATE','Loans','2026-02-21'),
(5049,'system','INSERT','Transactions','2026-02-22'),
(5050,'admin','UPDATE','Accounts','2026-02-23');

SELECT * FROM Compliance.AuditLog;

-- ============================================
-- DATA: HR.Employees
-- ============================================

INSERT INTO HR.Employees (EmployeeID, Name, Position, Salary)
VALUES
(6001,'Robert Miller','Branch Manager',75000),
(6002,'Linda Anderson','Accountant',60000),
(6003,'James Wilson','Loan Officer',65000),
(6004,'Patricia Taylor','Teller',42000),
(6005,'Michael Moore','Customer Service Rep',40000),
(6006,'Barbara Jackson','Teller',41000),
(6007,'William Martin','IT Specialist',70000),
(6008,'Elizabeth Lee','HR Manager',68000),
(6009,'David Perez','Security Officer',45000),
(6010,'Jennifer White','Accountant',61000),
(6011,'Richard Harris','Loan Officer',66000),
(6012,'Susan Clark','Teller',41500),
(6013,'Joseph Lewis','Customer Service Rep',39500),
(6014,'Karen Robinson','HR Assistant',47000),
(6015,'Thomas Walker','Branch Manager',76000),
(6016,'Nancy Hall','Accountant',60500),
(6017,'Charles Allen','IT Specialist',72000),
(6018,'Margaret Young','Teller',40500),
(6019,'Christopher King','Loan Officer',67000),
(6020,'Lisa Wright','Customer Service Rep',39000),
(6021,'Daniel Scott','Security Officer',46000),
(6022,'Betty Green','Teller',40000),
(6023,'Matthew Baker','IT Specialist',71000),
(6024,'Sandra Adams','HR Manager',69000),
(6025,'Anthony Nelson','Accountant',62000),
(6026,'Ashley Hill','Customer Service Rep',39500),
(6027,'Mark Campbell','Loan Officer',65500),
(6028,'Dorothy Mitchell','Teller',41000),
(6029,'Steven Carter','Security Officer',45500),
(6030,'Donna Roberts','Accountant',61500),
(6031,'Paul Gomez','IT Specialist',70500),
(6032,'Carol Phillips','HR Assistant',48000),
(6033,'Andrew Evans','Loan Officer',66000),
(6034,'Ruth Turner','Teller',40500),
(6035,'Joshua Diaz','Customer Service Rep',40000),
(6036,'Sharon Parker','Accountant',60000),
(6037,'Kevin Cruz','Security Officer',45000),
(6038,'Laura Edwards','HR Manager',70000),
(6039,'Brian Collins','IT Specialist',71500),
(6040,'Amy Stewart','Teller',41000),
(6041,'Jason Morris','Loan Officer',67000),
(6042,'Angela Rogers','Customer Service Rep',39500),
(6043,'Eric Reed','Accountant',62000),
(6044,'Brenda Cook','HR Assistant',47000),
(6045,'Adam Morgan','Security Officer',46000),
(6046,'Janet Bell','Teller',40500),
(6047,'Ryan Murphy','IT Specialist',72500),
(6048,'Rebecca Bailey','Customer Service Rep',39000),
(6049,'Justin Rivera','Loan Officer',66500),
(6050,'Teresa Cooper','Accountant',61000);

SELECT * FROM HR.Employees;

-- ============================================
-- FINAL VERIFICATION SELECTS
-- ============================================

SELECT * FROM Accounts.Customers;
SELECT * FROM Accounts.Accounts;
SELECT * FROM Accounts.Transactions;
SELECT * FROM Loans.Loans;
SELECT * FROM Loans.Payments;
SELECT * FROM Compliance.AuditLog;
SELECT * FROM HR.Employees;