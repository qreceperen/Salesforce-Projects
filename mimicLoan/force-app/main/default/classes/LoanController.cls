public with sharing class LoanController {
    // Method to get loans associated with specific account
    @AuraEnabled(cacheable=true)
    public static List<Loan__c> getLoans(Id accountId){
        return [
            SELECT 
                Id,
                Name,
                Loan_Type__c,
                Loan_Amount__c,
                Interest_Rate__c,
                Loan_Term__c,
                Application_Status__c
            FROM    
                Loan__c
            WHERE Related_Account__c = :accountId
        ];
    }
}