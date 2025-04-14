public with sharing class RefundProcessor {
    @AuraEnabled(cacheable = true)
    public static List<FinTrack_Payment__c> getRelatedPaymentsWithInvoiceId(Id InvoiceId){
        return [SELECT Id, Name, Amount_Paid__c FROM FinTrack_Payment__c WHERE Invoice__c = :InvoiceId];
    }

    @AuraEnabled
    public static String processRefund(Id paymentId, Decimal refundAmount){
        if(paymentId == null || refundAmount == null || refundAmount <=0){
            return 'Invalid refund request. Please provide a valid payment and refund amount.';
        }

        // Step 1. Get the payment
        FinTrack_Payment__c payment = [SELECT Id, Amount_Paid__c, Invoice__c, Invoice__r.Account__c FROM FinTrack_Payment__c WHERE Id = :paymentId LIMIT 1];

        // Step 2 Check if refund exceeds payment amount.
        if(refundAmount > payment.Amount_Paid__c){
            return 'Refund amount exceeds the payment amount.';
        }

        //Step 3 Subtrack from payment amount
        payment.Amount_Paid__c = payment.Amount_Paid__c - refundAmount;

        //Step 4 Create negative Financial Transaction
        Financial_Transaction__c refundTransaction = new Financial_Transaction__c();
        refundTransaction.Amount__c = -refundAmount;
        refundTransaction.FinTrack_Payment__c = payment.Id;
        refundTransaction.Transaction_Type__c = 'Refund';
        refundTransaction.Transaction_Date__c = Date.today();
        refundTransaction.Account__c = payment.Invoice__r.Account__c;

        try{
            update payment;
            insert refundTransaction;
            return 'Refund Processed successfully';

        } catch(Exception e){
            return 'Refund process failed. '+ e.getMessage();
        }
    }
}

