USE BankDB;
GO

-- ============================================
-- ASSIGN USERS TO ROLES
-- ============================================

EXEC sp_addrolemember 'Tellers',            'Teller_Kevin';
EXEC sp_addrolemember 'LoanOfficers',       'LoanOfficer_Pam';
EXEC sp_addrolemember 'ComplianceOfficers', 'Compliance_Oscar';
EXEC sp_addrolemember 'BranchManager',      'BranchManager_Michael';
EXEC sp_addrolemember 'HRStaff',            'HR_Toby';


EXEC sp_addrolemember 'LoanOfficers', 'BranchManager_Michael';
EXEC sp_addrolemember 'Tellers',      'BranchManager_Michael';
GO

-- ============================================
-- 1. TELLERS (Teller_Kevin)
-- ============================================

GRANT SELECT ON OBJECT::[Accounts].[Customers] TO Tellers;
DENY  SELECT ON OBJECT::[Accounts].[Customers] (SSN) TO Tellers;

GRANT SELECT ON OBJECT::[Accounts].[Accounts] TO Tellers;

REVOKE SELECT ON OBJECT::[Accounts].[Transactions] TO Tellers;
GO
GRANT INSERT ON OBJECT::[Accounts].[Transactions] TO Tellers;
DENY  UPDATE ON OBJECT::[Accounts].[Transactions] TO Tellers;
DENY  DELETE ON OBJECT::[Accounts].[Transactions] TO Tellers;

DENY  INSERT ON OBJECT::[Accounts].[Accounts] TO Tellers;
DENY  UPDATE ON OBJECT::[Accounts].[Accounts] TO Tellers;
DENY  DELETE ON OBJECT::[Accounts].[Accounts] TO Tellers;
GO

-- ============================================
-- 2. LOAN OFFICERS (LoanOfficer_Pam)
-- ============================================

GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[Loans].[Loans]    TO LoanOfficers;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[Loans].[Payments] TO LoanOfficers;

GRANT SELECT ON OBJECT::[Accounts].[Customers] TO LoanOfficers;

DENY SELECT ON OBJECT::[Accounts].[Transactions] TO LoanOfficers;
DENY INSERT ON OBJECT::[Accounts].[Transactions] TO LoanOfficers;
DENY UPDATE ON OBJECT::[Accounts].[Transactions] TO LoanOfficers;
DENY DELETE ON OBJECT::[Accounts].[Transactions] TO LoanOfficers;
GO

-- ============================================
-- 3. COMPLIANCE OFFICERS (Compliance_Oscar)
-- ============================================

GRANT SELECT ON OBJECT::[Compliance].[AuditLog] TO ComplianceOfficers;
DENY  INSERT ON OBJECT::[Compliance].[AuditLog] TO ComplianceOfficers;
DENY  UPDATE ON OBJECT::[Compliance].[AuditLog] TO ComplianceOfficers;
DENY  DELETE ON OBJECT::[Compliance].[AuditLog] TO ComplianceOfficers;

GRANT SELECT ON OBJECT::[Accounts].[Customers]    TO ComplianceOfficers;
GRANT SELECT ON OBJECT::[Accounts].[Accounts]     TO ComplianceOfficers;
GRANT SELECT ON OBJECT::[Accounts].[Transactions] TO ComplianceOfficers;

DENY INSERT ON OBJECT::[Accounts].[Customers] TO ComplianceOfficers;
DENY UPDATE ON OBJECT::[Accounts].[Customers] TO ComplianceOfficers;
DENY DELETE ON OBJECT::[Accounts].[Customers] TO ComplianceOfficers;

DENY INSERT ON OBJECT::[Accounts].[Accounts] TO ComplianceOfficers;
DENY UPDATE ON OBJECT::[Accounts].[Accounts] TO ComplianceOfficers;
DENY DELETE ON OBJECT::[Accounts].[Accounts] TO ComplianceOfficers;

DENY INSERT ON OBJECT::[Accounts].[Transactions] TO ComplianceOfficers;
DENY UPDATE ON OBJECT::[Accounts].[Transactions] TO ComplianceOfficers;
DENY DELETE ON OBJECT::[Accounts].[Transactions] TO ComplianceOfficers;
GO

-- ============================================
-- 4. BRANCH MANAGER (BranchManager_Michael)
--    DENY on the USER directly so it overrides
--    inherited GRANTs from role membership
-- ============================================

DENY DELETE ON OBJECT::[Accounts].[Transactions]    TO BranchManager_Michael;
DENY UPDATE ON OBJECT::[Loans].[Loans] (InterestRate) TO BranchManager_Michael;
GO

-- ============================================
-- 5. HR STAFF (HR_Toby)
-- ============================================

GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::[HR].[Employees] TO HRStaff;

DENY SELECT, INSERT, UPDATE, DELETE ON OBJECT::[Accounts].[Customers]    TO HRStaff;
DENY SELECT, INSERT, UPDATE, DELETE ON OBJECT::[Accounts].[Accounts]     TO HRStaff;
DENY SELECT, INSERT, UPDATE, DELETE ON OBJECT::[Accounts].[Transactions] TO HRStaff;

DENY SELECT, INSERT, UPDATE, DELETE ON OBJECT::[Loans].[Loans]    TO HRStaff;
DENY SELECT, INSERT, UPDATE, DELETE ON OBJECT::[Loans].[Payments] TO HRStaff;

DENY SELECT, INSERT, UPDATE, DELETE ON OBJECT::[Compliance].[AuditLog] TO HRStaff;
GO

