/**
 * Trigger for Training_Enrollment__c object
 */
trigger TrainingEnrollmentTrigger on Training_Enrollment__c (
    before insert, before update, before delete,
    after insert, after update, after delete, after undelete
) {
    new TrainingEnrollmentHandler().execute();
}