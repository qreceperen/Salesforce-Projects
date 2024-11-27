trigger LoanApplicationTrigger on Loan_Application__c (after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        LoanApplicationHandler.createLoanConditions(Trigger.New);
    }
}
