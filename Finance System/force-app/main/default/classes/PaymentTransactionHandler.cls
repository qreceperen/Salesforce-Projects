public with sharing class PaymentTransactionHandler {

    public static void handleAfterInsert(List<FinTrack_Payment__c> newPayments){
        // Step 1: Collect Invoice IDs from payments
        Set<Id> relatedInvoices = collectInvoiceIds(newPayments);

        // Step 2: Aggregate total paid per invoice (already includes current payments since this is AFTER trigger)
        Map<Id, Decimal> totalPaymentPerInvoiceMap = fetchInvoiceTotals(relatedInvoices);

        // Step 3: Get related Invoices and fields comparison. 
        Map<Id, FinTrack_Invoice__c> invoiceMap = fetchInvoiceMap(relatedInvoices);

        // Step 4: Validate payments and prepare Financial Transactions
        List<Financial_Transaction__c> transactionsToInsert = new List<Financial_Transaction__c>();
        for(FinTrack_Payment__c payment : newPayments){
            Financial_Transaction__c singleFinancialTransaction = validateAndBuildTransaction(payment, totalPaymentPerInvoiceMap, invoiceMap);
            if(singleFinancialTransaction != null){
                transactionsToInsert.add(singleFinancialTransaction);
            }
        }


        // Step 5: Insert Transactions if any valid ones exist
        if (!transactionsToInsert.isEmpty()) {
            try {
                insert transactionsToInsert;
            } catch (Exception e) {
                // Log error — in production, you might use a platform event or error log object
                System.debug('Error inserting Financial Transactions: ' + e.getMessage());
            }
        }

    }

    public static void handleAfterUpdate(List<FinTrack_Payment__c> newPayments, Map<Id, FinTrack_Payment__c> oldPaymentsMap){
         // in order to compare total payment not exceeds Total Invoice
         Set<Id> relatedInvoices = new Set<Id>();
         Set<Id> changedPaymentIds = new Set<Id>();
         for(FinTrack_Payment__c payment : newPayments){
             if(payment.Amount_Paid__c != oldPaymentsMap.get(payment.Id).Amount_Paid__c){
                 relatedInvoices.add(payment.Invoice__c);
                 changedPaymentIds.add(payment.Id);
             }
         }
 
         //Get Total Paid Amount after current Update
         Map<Id, Decimal> totalPaymentPerInvoiceMap = fetchInvoiceTotals(relatedInvoices);
         Map<Id, FinTrack_Invoice__c> invoiceMap = fetchInvoiceMap(relatedInvoices);  

 
         //Get All realted payments and check if there is an existing record. Updates the existing Transaction instead of creating a new one.
         List<Financial_Transaction__c> trans = [SELECT Id, FinTrack_Payment__c, Amount__c FROM Financial_Transaction__c WHERE FinTrack_Payment__c IN: changedPaymentIds];
         Map<Id, Financial_Transaction__c> relatedFinTransactionsMap = new Map<Id, Financial_Transaction__c>();
         for(Financial_Transaction__c tran : trans){
             relatedFinTransactionsMap.put(tran.FinTrack_Payment__c, tran);
         }
         List<Financial_Transaction__c> transactionsToUpdate = new List<Financial_Transaction__c>();

         for (FinTrack_Payment__c payment : newPayments) {
            if (changedPaymentIds.contains(payment.Id) && relatedFinTransactionsMap.containsKey(payment.Id)) {
        
                Financial_Transaction__c validatedTrans = validateAndBuildTransaction(
                    payment,
                    totalPaymentPerInvoiceMap,
                    invoiceMap
                );
        
                if (validatedTrans != null) {
                    Financial_Transaction__c existingTrans = relatedFinTransactionsMap.get(payment.Id);
                    existingTrans.Amount__c = validatedTrans.Amount__c;
                    existingTrans.Transaction_Date__c = validatedTrans.Transaction_Date__c;
                    // optional: update more fields if needed later
                    transactionsToUpdate.add(existingTrans);
                }
            }
        }
        
         try{
             if(!transactionsToUpdate.isEmpty()){
                 update transactionsToUpdate;
             }
         } catch (Exception e){
             System.debug('Error updating existing transactions: ' + e.getMessage());
         }
    }

    private static Set<Id> collectInvoiceIds(List<FinTrack_Payment__c> payments){
        Set<Id> returnRelatedInvoices = new Set<Id>();
        for (FinTrack_Payment__c payment : payments) {
            if (payment.Invoice__c != null) {
                returnRelatedInvoices.add(payment.Invoice__c);
            }
        }
        return returnRelatedInvoices;
    }

    private static Map<Id, Decimal> fetchInvoiceTotals(Set<Id> relatedInvoices){
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
        return totalPaymentPerInvoiceMap;
    }

    private static Map<Id,FinTrack_Invoice__c> fetchInvoiceMap(Set<Id> relatedInvoices){
        List<FinTrack_Invoice__c> invoicesList = [
            SELECT Id, Account__c, Name, Total_Amount__c
            FROM FinTrack_Invoice__c
            WHERE Id IN :relatedInvoices
            ];
            Map<Id, FinTrack_Invoice__c> invoiceMap = new Map<Id, FinTrack_Invoice__c>(invoicesList);
        return invoiceMap;
    }

    private static Financial_Transaction__c validateAndBuildTransaction(FinTrack_Payment__c payment, Map<Id,Decimal> totalPaymentPerInvoiceMap, Map<Id,FinTrack_Invoice__c> invoiceMap){
        Financial_Transaction__c singleTransaction = new Financial_Transaction__c();
        if (payment.Invoice__c != null && invoiceMap.containsKey(payment.Invoice__c)) {
            Decimal totalPaidIncludingCurrent = totalPaymentPerInvoiceMap.get(payment.Invoice__c);
            Decimal invoiceTotal = invoiceMap.get(payment.Invoice__c).Total_Amount__c;
    
            if (totalPaidIncludingCurrent > invoiceTotal) {
                payment.addError('Payment exceeds the total invoice amount.');
                return null; // ❗ prevents invalid transaction
            } else {
                singleTransaction.Amount__c = payment.Amount_Paid__c;
                singleTransaction.Account__c = invoiceMap.get(payment.Invoice__c).Account__c;
                singleTransaction.FinTrack_Payment__c = payment.Id;
                singleTransaction.Transaction_Type__c = 'Income';
                singleTransaction.Transaction_Date__c = payment.Payment_Date__c;
                return singleTransaction;
            }
        }
        return null;

    }

}