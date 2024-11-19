List<LoanConditionsMetadata__mdt> loanConditionsMetadata = [
    SELECT Loan_Type__c, Condition_Name__c
    FROM LoanConditionsMetadata__mdt
];

Map<String, List<LoanConditionsMetadata__mdt>> loanTypeToMetaDataMap = new Map<String, List<LoanConditionsMetadata__mdt>>();

for(LoanConditionsMetadata__mdt metadata : loanConditionsMetadata){
    // Check if the LoanType is already in the Map
    if(!loanTypeToMetaDataMap.containsKey(metadata.Loan_Type__c)){
        loanTypeToMetaDataMap.put(metadata.Loan_Type__c, new List<LoanConditionsMetadata__mdt>());
    }
    // Add the metadata record to the appropriate loan Type List
    loanTypeToMetaDataMap.get(metadata.Loan_Type__c).add(metadata);
}
// Loop through the map to debug each Loan Type and its corresponding conditions
for (String loanType : loanTypeToMetadataMap.keySet()) {
    System.debug('Loan Type: ' + loanType);
    List<LoanConditionsMetadata__mdt> conditions = loanTypeToMetadataMap.get(loanType);
    for (LoanConditionsMetadata__mdt condition : conditions) {
        System.debug('   Condition Name: ' + condition.Condition_Name__c);
    }
}