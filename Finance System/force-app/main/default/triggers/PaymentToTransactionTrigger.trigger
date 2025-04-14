trigger PaymentToTransactionTrigger on FinTrack_Payment__c (after insert, after update) {

    if(Trigger.isAfter && Trigger.isInsert){
        PaymentTransactionHandler.handleAfterInsert(Trigger.New);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        PaymentTransactionHandler.handleAfterUpdate(Trigger.New, Trigger.OldMap);

    }

}
