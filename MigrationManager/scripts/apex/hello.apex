// ========================================
// Create sample data for LWC migration test
// ========================================

MTB_Entity__c entity = new MTB_Entity__c(
    Business_Type__c = 'LLC',
    Establishment_Date__c = Date.newInstance(2020, 1, 1)
);
insert entity;

Digital_Loan_Application__c dla = new Digital_Loan_Application__c(
    Entity__c = entity.Id,
    Business_And_DBA_Name__c = 'Test Business LLC',
    Status__c = 'Submitted',
    Submission_Date__c = Date.today(),
    Ready_to_Migrate__c = true,
    Migrated_to_nCino__c = false
);
insert dla;

MTB_Demographics__c demo = new MTB_Demographics__c(
    Digital_Loan_Application__c = dla.Id,
    Record_Source__c = 'DLA',
    Demographics_Status__c = 'Pending'
);
insert demo;

