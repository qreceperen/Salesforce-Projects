public with sharing class PaymentTransactionHandler {

    public static void handleFinancialTransactions(List<FinTrack_Payment__c> newPayments){
       
        //Collect All Unique Invoices Ids
        Set<Id> invoiceIds = new Set<Id>();
        for(FinTrack_Payment__c payment : newPayments){
            if(payment.Invoice__c != null){
                invoiceIds.add(payment.Invoice__c);
            }
        }
        Map<Id,FinTrack_Invoice__c> invoiceDetails = fetchInvoiceDetails(invoiceIds);

        Map<Id, Decimal> invoiceTotalPaidMap = fetchTotalPaidAmounts(invoiceIds); // Bring what will be the total amount paid on invoice within new payment to make further calculations.

        List<Financial_Transaction__c> transactions = validatePayments(newPayments, invoiceDetails, invoiceTotalPaidMap);

        if(!transactions.isEmpty()){
            Database.insert(transactions, false);
        }

    }

    private static Map<Id, FinTrack_Invoice__c> fetchInvoiceDetails(Set<Id> invoiceIds){
            // Query related invoices to get Account__c (avoids Null Reference Errors)
            return new Map<Id, FinTrack_Invoice__c>([SELECT Id, Account__c, Total_Amount__c FROM FinTrack_Invoice__c WHERE Id IN :invoiceIds]); 
    }

    private static Map<Id, Decimal> fetchTotalPaidAmounts(Set<Id> invoiceIds){
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
        return invoiceToTotalPaidMap;
    }

    private static List<Financial_Transaction__c> validatePayments(List<FinTrack_Payment__c> newPayments, Map<Id, FinTrack_Invoice__c> invoiceDetails, Map<Id, Decimal> invoiceTotalPaidMap) {
        List<Financial_Transaction__c> transactions = new List<Financial_Transaction__c>();
        for(FinTrack_Payment__c payment : newPayments){
            if(payment.Invoice__c !=null && invoiceDetails.containsKey(payment.Invoice__c)){
                Decimal totalPaid = invoiceTotalPaidMap.containsKey(payment.Invoice__c) ? invoiceTotalPaidMap.get(payment.Invoice__c):0;

                // Check if new payment exceeds the invoice total
                if(totalPaid <= invoiceDetails.get(payment.Invoice__c).Total_Amount__c){
                    Financial_Transaction__c trans = new Financial_Transaction__c();
                    trans.Amount__c = payment.Amount_Paid__c;
                    trans.FinTrack_Payment__c = payment.Id;
                    trans.Transaction_Type__c = 'Income';
                    trans.Transaction_Date__c = payment.Payment_Date__c;
                    trans.Account__c = invoiceDetails.get(payment.Invoice__c).Account__c;
                    transactions.add(trans);
                } else {
                    payment.addError('Payment exceeds the total invoice amount.');
                }
            }
        }
        return transactions;
    }


}