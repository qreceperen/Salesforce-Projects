public with sharing class RefundProcessor {
    @AuraEnabled
    public static String processRefund(Id paymentId, Decimal refundAmount) {
        // Ensure input validation
        if (paymentId == null || refundAmount == null || refundAmount <= 0) {
            return 'Invalid refund request. Please provide a valid payment and refund amount.';
        }

        // Query Payment and Related Invoice
        FinTrack_Payment__c payment = [
            SELECT Id, Amount_Paid__c, Invoice__c, Invoice__r.Status__c, Invoice__r.Account__c
            FROM FinTrack_Payment__c 
            WHERE Id = :paymentId 
            LIMIT 1
        ];

        // Validate Refund Amount
        if (refundAmount > payment.Amount_Paid__c) {
            return 'Refund amount exceeds the payment amount.';
        }

        // **Update Payment Amount**
        payment.Amount_Paid__c -= refundAmount;

        // **Create a New Financial Transaction for the Refund**
        Financial_Transaction__c refundTransaction = new Financial_Transaction__c();
        refundTransaction.Amount__c = -refundAmount; // Negative transaction to record refund
        refundTransaction.Transaction_Type__c = 'Refund';
        refundTransaction.Transaction_Date__c = Date.today();
        refundTransaction.FinTrack_Payment__c = payment.Id; // Link to Payment
        refundTransaction.Account__c = payment.Invoice__r.Account__c; // Link to Account from Invoice

        // List to store records that need updating
        List<sObject> recordsToUpdate = new List<sObject>();

        // **Update Payment Record**
        recordsToUpdate.add(payment);


        // **Perform DML Operations**
        try {
            update recordsToUpdate; // Update Payment and Invoice
            insert refundTransaction; // Insert the refund transaction
            return 'Refund processed successfully.';
        } catch (Exception e) {
            return 'Error processing refund: ' + e.getMessage();
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<FinTrack_Payment__c> getRelatedPaymentsWithInvoiceId(Id invoiceId){
        return [
            SELECT Id, Name, Amount_Paid__c
            FROM FinTrack_Payment__c
            WHERE Invoice__c = :invoiceId
        ];
    }
}
