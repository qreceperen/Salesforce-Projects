trigger PaymentToTransactionTrigger on FinTrack_Payment__c (after insert, after update) {

    if(Trigger.isAfter && Trigger.isInsert){
        PaymentTransactionHandler.handleFinancialTransactions(Trigger.New);
        
    }
}