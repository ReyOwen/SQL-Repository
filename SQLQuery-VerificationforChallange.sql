
use BankDB;
-- 1. Teller_Kevin
 EXECUTE AS USER = 'Teller_Kevin';
     SELECT CustomerID, Name, Address FROM [Accounts].[Customers];  -- OK
     SELECT SSN FROM [Accounts].[Customers];                        -- FAIL
     SELECT * FROM [Accounts].[Accounts];                           -- OK
     INSERT INTO [Accounts].[Transactions]
         VALUES (9999, 1001, 100.00, GETDATE());                    -- OK
     DELETE FROM [Accounts].[Transactions]
         WHERE TransactionID = 9999;                                -- FAIL
 REVERT;

-- 2. LoanOfficer_Pam
 EXECUTE AS USER = 'LoanOfficer_Pam';
     SELECT CustomerID, Name, SSN FROM [Accounts].[Customers];      -- OK
     SELECT * FROM [Loans].[Loans];                                 -- OK
     SELECT * FROM [Accounts].[Transactions];                       -- FAIL
 REVERT;

-- 3. Compliance_Oscar
 EXECUTE AS USER = 'Compliance_Oscar';
     SELECT * FROM [Compliance].[AuditLog];                         -- OK
     SELECT * FROM [Accounts].[Customers];                          -- OK
     DELETE FROM [Compliance].[AuditLog] WHERE LogID = 5001;        -- FAIL
 REVERT;

-- 4. BranchManager_Michael
 EXECUTE AS USER = 'BranchManager_Michael';
     SELECT * FROM [Accounts].[Transactions];                       -- FAIL
     SELECT * FROM [Loans].[Loans];                                 -- OK (via LoanOfficers role)
     DELETE FROM [Accounts].[Transactions]
         WHERE TransactionID = 2001;                                -- FAIL (explicit DENY)
     UPDATE [Loans].[Loans] SET InterestRate = 1.0
         WHERE LoanID = 3001;                                       -- FAIL (explicit DENY)
 REVERT;

-- 5. HR_Toby
 EXECUTE AS USER = 'HR_Toby';
     SELECT * FROM [HR].[Employees];                                -- OK
     SELECT * FROM [Accounts].[Customers];                          -- FAIL
     SELECT * FROM [Loans].[Loans];                                 -- FAIL
 REVERT;

