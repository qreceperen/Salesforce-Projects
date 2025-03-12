trigger PaymentToTransactionTrigger on FinTrack_Payment__c (after insert, after update) {
    if(Trigger.isAfter && Trigger.isInsert){
        List<Financial_Transaction__c> transactions = new List<Financial_Transaction__c>();

        for(FinTrack_Payment__c payment : Trigger.new){
            if(payment.Invoice__c != null){
                Financial_Transaction__c trans = new Financial_Transaction__c();
                trans.Amount__c = payment.Amount_Paid__c;
                trans.FinTrack_Payment__c = payment.Id;
                trans.Transaction_Type__c = 'Income';
                trans.Transaction_Date__c = payment.Payment_Date__c;
                transactions.add(trans);
            }
        }
        if(!transactions.isEmpty()){
            Database.insert(transactions, false);
        }
    }

}