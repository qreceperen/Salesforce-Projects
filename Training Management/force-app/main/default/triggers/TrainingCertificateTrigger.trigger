/**
 * Trigger for Training_Certificate__c object
 */
trigger TrainingCertificateTrigger on Training_Certificate__c (
    before insert, before update, before delete,
    after insert, after update, after delete, after undelete
) {
    new TrainingCertificateHandler().execute();
}