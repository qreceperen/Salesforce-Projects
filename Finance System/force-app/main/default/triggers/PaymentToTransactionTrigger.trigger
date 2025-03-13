trigger PaymentToTransactionTrigger on FinTrack_Payment__c (after insert, after update) {
    if(Trigger.isAfter && Trigger.isInsert){
        List<Financial_Transaction__c> transactions = new List<Financial_Transaction__c>();

        //Collect All Unique Invoices Ids
        Set<Id> invoiceIds = new Set<Id>();
        for(FinTrack_Payment__c payment : Trigger.New){
            if(payment.Invoice__c != null){
                invoiceIds.add(payment.Invoice__c);
            }
        }

        // Query related invoices to get Account__c (avoids Null Reference Errors)
        Map<Id, FinTrack_Invoice__c> invoiceMap = new Map<Id, FinTrack_Invoice__c>(
            [SELECT Id, Account__c FROM FinTrack_Invoice__c WHERE Id IN :invoiceIds]
        ); 


        // Use Aggregate SOQL to sum past payments for each Invoice
        Map<Id, Decimal> invoiceToTotalPaidMap = new Map<Id,Decimal>();
        for(AggregateResult ar : [
            SELECT Invoice__c, SUM(Amount_Paid__c) totalPaid
            FROM FinTrack_Payment__c
            WHERE Invoice__c IN :invoiceIds
            GROUP BY Invoice__c
        ]){
            invoiceToTotalPaidMap.put((Id) ar.get('Invoice__c'), (Decimal) ar.get('totalPaid'));
        }
        system.debug('Total Paid Map '+invoiceToTotalPaidMap);


        for(FinTrack_Payment__c payment : Trigger.new){
            if(payment.Invoice__c != null && invoiceMap.containsKey(payment.Invoice__c)){
                Financial_Transaction__c trans = new Financial_Transaction__c();
                trans.Amount__c = payment.Amount_Paid__c;
                trans.FinTrack_Payment__c = payment.Id;
                trans.Transaction_Type__c = 'Income';
                trans.Transaction_Date__c = payment.Payment_Date__c;
                trans.Account__c = invoiceMap.get(payment.Invoice__c).Account__c;
                transactions.add(trans);
            }
        }
        if(!transactions.isEmpty()){
            Database.insert(transactions, false);
        }
    }
}