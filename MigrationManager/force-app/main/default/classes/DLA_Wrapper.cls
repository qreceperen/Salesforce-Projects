// =====================================================
// FILE 4: DLA_Wrapper.cls (Simplified)
// =====================================================
public with sharing class DLA_Wrapper {
    
    private Digital_Loan_Application__c dla;
    private MTB_Entity__c entity;

    public DLA_Wrapper(Digital_Loan_Application__c dlaRecord) {
        dla = dlaRecord;
    }

    public Digital_Loan_Application__c getDLA() {
        return dla;
    }

    public MTB_Entity__c getEntity() {
        if(entity == null) {
            entity = [
                SELECT Id, Establishment_Date__c
                FROM MTB_Entity__c 
                WHERE Id = :dla.Entity__c 
                LIMIT 1
            ];
        }
        return entity;
    }
}