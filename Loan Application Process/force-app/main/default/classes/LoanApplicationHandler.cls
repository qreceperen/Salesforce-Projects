public with sharing class LoanApplicationHandler {
    public static void createLoanConditions(List<Loan_Application__c> loanApplications){
        Set<String> loanTypes = new Set<String>();
        for(Loan_Application__c loanApplication : loanApplications){
            loanTypes.add(loanApplication.Loan_Type__c);
        }

        // Query all Related Custom Metadata
        List<LoanConditionsMetadata__mdt> allLoanConditionsMetadata  = [SELECT Id, Loan_Type__c ,Condition_Name__c FROM LoanConditionsMetadata__mdt WHERE Loan_Type__c IN :loanTypes];
        
        // Create a Map to store all Loan Condition Name and its Label
        Map<String, List<LoanConditionsMetadata__mdt>> conditionsMap = new Map<String, List<LoanConditionsMetadata__mdt>>();

        for(LoanConditionsMetadata__mdt condition : allLoanConditionsMetadata ){
            if (!conditionsMap.containsKey(condition.Loan_Type__c)) {
                conditionsMap.put(condition.Loan_Type__c, new List<LoanConditionsMetadata__mdt>());
            }
            conditionsMap.get(condition.Loan_Type__c).add(condition);
            
        }

        List<Loan_Condition__c> loanConditionsToInsert = new List<Loan_Condition__c>();
        for(Loan_Application__c loanApplication : loanApplications){
            List<LoanConditionsMetadata__mdt> specificLoanConditions = conditionsMap.get(loanApplication.Loan_Type__c);
            if(specificLoanConditions != null && !specificLoanConditions.isEmpty()){
                for(LoanConditionsMetadata__mdt  condition : specificLoanConditions){
                    Loan_Condition__c loanCondition = new Loan_Condition__c();
                    loanCondition.Loan_Application__c = loanApplication.Id;
                    loanCondition.Condition_Name__c = condition.Condition_Name__c;
                    loanCondition.Status__c = 'In Progress';
                    loanConditionsToInsert.add(loanCondition);
                }
            }
        }
        if(!loanConditionsToInsert.isEmpty()){
            insert loanConditionsToInsert;
        }
    }
}