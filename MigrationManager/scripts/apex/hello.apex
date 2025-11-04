// =======================================================
// STEP 1: Create supporting Entity record
// =======================================================
MTB_Entity__c entity = new MTB_Entity__c(
    Business_Type__c = 'LLC',
    Establishment_Date__c = Date.newInstance(2020, 1, 1)
);
insert entity;
System.debug('✅ Created Entity: ' + entity.Id);

// =======================================================
// STEP 2: Create a DLA (Digital Loan Application)
// =======================================================
Digital_Loan_Application__c dla = new Digital_Loan_Application__c(
    Entity__c = entity.Id,
    Business_And_DBA_Name__c = 'ProcessHandler Business LLC',
    Status__c = 'Submitted',
    Submission_Date__c = Date.today(),
    Ready_to_Migrate__c = true,
    Migrated_to_nCino__c = false
);
insert dla;
System.debug('✅ Created DLA: ' + dla.Id);

// =======================================================
// STEP 3: Create one Demographics record linked to DLA
// =======================================================
MTB_Demographics__c demo = new MTB_Demographics__c(
    Digital_Loan_Application__c = dla.Id,
    Record_Source__c = 'DLA',
    Demographics_Status__c = 'Pending'
);
insert demo;
System.debug('✅ Created Demo: ' + demo.Id);

// =======================================================
// STEP 4: Call the ProcessHandler (main orchestrator)
// =======================================================
System.debug('🚀 Calling DLA_ProcessHandler.run for DLA Id -> ' + dla.Id);
Map<String, String> result = DLA_ProcessHandler.run(dla.Id);
System.debug('🏁 ProcessHandler returned result: ' + result);

// =======================================================
// STEP 5: Verify updates
// =======================================================
Digital_Loan_Application__c updatedDla = [
    SELECT Id, Migrated_to_nCino__c FROM Digital_Loan_Application__c WHERE Id = :dla.Id
];
System.debug('🔍 DLA.Migrated_to_nCino__c = ' + updatedDla.Migrated_to_nCino__c);

MTB_Demographics__c updatedDemo = [
    SELECT Id, Date_Form_Received__c, Years_in_Business__c,
           Application_Method__c, Legal_Business_Applicant_Name__c,
           Record_Source__c, Origination_System__c
    FROM MTB_Demographics__c
    WHERE Id = :demo.Id
];
System.debug('🔍 Updated Demo record: ' + updatedDemo);
