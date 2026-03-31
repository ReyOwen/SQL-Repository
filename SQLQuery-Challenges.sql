USE BankDB;
GO

-- ============================================
-- TEST 1: Things Michael CAN do
-- All should return results with NO errors
-- ============================================

-- Via Tellers role: view customers
EXECUTE AS USER = 'BranchManager_Michael';
    SELECT CustomerID, Name, Address FROM [Accounts].[Customers];
REVERT;

-- Via Tellers role: view accounts
EXECUTE AS USER = 'BranchManager_Michael';
    SELECT * FROM [Accounts].[Accounts];
REVERT;

-- Via Tellers role: insert a transaction
EXECUTE AS USER = 'BranchManager_Michael';
    INSERT INTO [Accounts].[Transactions]
        VALUES (7777, 1001, 200.00, GETDATE());
REVERT;

-- Via LoanOfficers role: view loans
EXECUTE AS USER = 'BranchManager_Michael';
    SELECT * FROM [Loans].[Loans];
REVERT;

-- Via LoanOfficers role: view customer SSN
EXECUTE AS USER = 'BranchManager_Michael';
    SELECT CustomerID, Name, SSN FROM [Accounts].[Customers];
REVERT;

-- Via LoanOfficers role: update a loan (anything EXCEPT InterestRate)
EXECUTE AS USER = 'BranchManager_Michael';
    UPDATE [Loans].[Loans]
        SET Amount = 11000
        WHERE LoanID = 3001;
REVERT;

GO

-- ============================================
-- TEST 2: Things Michael CANNOT do
-- Both should return Msg 229 (permission denied)
-- That error = the DENY is working correctly
-- ============================================

-- DENY 1: Cannot DELETE transactions
-- Expected: Msg 229, The DELETE permission was denied
EXECUTE AS USER = 'BranchManager_Michael';
    DELETE FROM [Accounts].[Transactions]
        WHERE TransactionID = 7777;
REVERT;

-- DENY 2: Cannot UPDATE InterestRate specifically
-- Expected: Msg 229, The UPDATE permission was denied
EXECUTE AS USER = 'BranchManager_Michael';
    UPDATE [Loans].[Loans]
        SET InterestRate = 1.0
        WHERE LoanID = 3001;
REVERT;

GO

-- ============================================
-- CLEANUP: Remove the test transaction
-- Run as yourself (dbo) after reverting
-- ============================================
DELETE FROM [Accounts].[Transactions] WHERE TransactionID = 7777;
