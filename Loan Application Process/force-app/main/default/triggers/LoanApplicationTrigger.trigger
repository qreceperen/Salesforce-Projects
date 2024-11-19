trigger LoanApplicationTrigger on Loan_Application__c (after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        Set<String> loanTypes = new Set<String>();

        // Step 1: Get all Loan Types
        for(Loan_Application__c loanApplication : Trigger.New){
            loanTypes.add(loanApplication.Loan_Type__c);
        }

        // Step 2: Query all related meta data and initialize Map for easy access
        List<LoanConditionsMetadata__mdt> relatedLoanConditionsMetadata = [SELECT Id, Loan_Type__c, Condition_Name__c FROM LoanConditionsMetadata__mdt WHERE Loan_Type__c IN :loanTypes];
        Map<String, List<LoanConditionsMetadata__mdt>> conditionsMap = new Map<String, List<LoanConditionsMetadata__mdt>>();

        // Loop relatedLoanConditionsMetadata and populate the map

        for(LoanConditionsMetadata__mdt conditionMetadata : relatedLoanConditionsMetadata){
            if(!conditionsMap.containsKey(conditionMetadata.Loan_Type__c)){
                conditionsMap.put(conditionMetadata.Loan_Type__c, new List<LoanConditionsMetadata__mdt>{conditionMetadata});
            } else {
                conditionsMap.get(conditionMetadata.Loan_Type__c).add(conditionMetadata);
            }
        }
    }
}
