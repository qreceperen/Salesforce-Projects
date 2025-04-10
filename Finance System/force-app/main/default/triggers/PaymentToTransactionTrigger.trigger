trigger PaymentToTransactionTrigger on FinTrack_Payment__c (after insert, after update) {

    if(Trigger.isAfter && Trigger.isInsert){
        // Step 1: Collect Invoice IDs from payments
        Set<Id> relatedInvoices = new Set<Id>();
        for (FinTrack_Payment__c payment : Trigger.New) {
            if (payment.Invoice__c != null) {
                relatedInvoices.add(payment.Invoice__c);
            }
        }
    
        // Step 2: Aggregate total paid per invoice (already includes current payments since this is AFTER trigger)
        List<AggregateResult> results = [
            SELECT Invoice__c, SUM(Amount_Paid__c) totalPaid
            FROM FinTrack_Payment__c
            WHERE Invoice__c IN :relatedInvoices
            GROUP BY Invoice__c
        ];
    
        Map<Id, Decimal> totalPaymentPerInvoiceMap = new Map<Id, Decimal>();
        for (AggregateResult result : results) {
            Id invoiceId = (Id) result.get('Invoice__c');
            Decimal totalPaid = (Decimal) result.get('totalPaid');
            totalPaymentPerInvoiceMap.put(invoiceId, totalPaid);
        }
    
        // Step 3: Query related Invoices
        List<FinTrack_Invoice__c> invoicesList = [
            SELECT Id, Account__c, Name, Total_Amount__c
            FROM FinTrack_Invoice__c
            WHERE Id IN :relatedInvoices
        ];
        Map<Id, FinTrack_Invoice__c> invoiceMap = new Map<Id, FinTrack_Invoice__c>(invoicesList);
    
        // Step 4: Validate payments and prepare Financial Transactions
        List<Financial_Transaction__c> trans = new List<Financial_Transaction__c>();
        for (FinTrack_Payment__c payment : Trigger.New) {
            if (payment.Invoice__c != null && invoiceMap.containsKey(payment.Invoice__c)) {
                Decimal totalPaidIncludingCurrent = totalPaymentPerInvoiceMap.containsKey(payment.Invoice__c)
                    ? totalPaymentPerInvoiceMap.get(payment.Invoice__c)
                    : 0;
                Decimal invoiceTotal = invoiceMap.get(payment.Invoice__c).Total_Amount__c;
    
                if (totalPaidIncludingCurrent > invoiceTotal) {
                    payment.addError('Payment exceeds the total invoice amount.');
                } else {
                    Financial_Transaction__c tran = new Financial_Transaction__c();
                    tran.Amount__c = payment.Amount_Paid__c;
                    tran.Account__c = invoiceMap.get(payment.Invoice__c).Account__c;
                    tran.FinTrack_Payment__c = payment.Id;
                    tran.Transaction_Type__c = 'Income';
                    tran.Transaction_Date__c = payment.Payment_Date__c;
                    trans.add(tran);
                }
            }
        }
    
        // Step 5: Insert Transactions if any valid ones exist
        if (!trans.isEmpty()) {
            try {
                insert trans;
            } catch (Exception e) {
                // Log error — in production, you might use a platform event or error log object
                System.debug('Error inserting Financial Transactions: ' + e.getMessage());
            }
        }
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        // in order to compare total payment not exceeds Total Invoice
        Set<Id> relatedInvoices = new Set<Id>();
        Set<Id> changedPaymentIds = new Set<Id>();
        for(FinTrack_Payment__c payment : Trigger.New){
            if(payment.Amount_Paid__c != Trigger.OldMap.get(payment.Id).Amount_Paid__c){
                relatedInvoices.add(payment.Invoice__c);
                changedPaymentIds.add(payment.Id);
            }
        }

        List<Financial_Transaction__c> trans = [SELECT Id, FinTrack_Payment__c, Amount__c FROM Financial_Transaction__c WHERE FinTrack_Payment__c IN: changedPaymentIds];
        Map<Id, Financial_Transaction__c> relatedFinTransactionsMap = new Map<Id, Financial_Transaction__c>();
        for(Financial_Transaction__c tran : trans){
            relatedFinTransactionsMap.put(tran.FinTrack_Payment__c, tran);
        }
        system.debug(relatedFinTransactionsMap);
        List<Financial_Transaction__c> transactionsToBeUpdate = new List<Financial_Transaction__c>();
        for(FinTrack_Payment__c payment : Trigger.New){
            if(changedPaymentIds.contains(payment.Id) && relatedFinTransactionsMap.containsKey(payment.Id)){
                Financial_Transaction__c finTran = relatedFinTransactionsMap.get(payment.Id);
                finTran.Amount__c = payment.Amount_Paid__c;
                transactionsToBeUpdate.add(finTran);
            }
        }
        update transactionsToBeUpdate;


    }

}
