/**
 * Trigger for Training_Course__c object
 */
trigger TrainingCourseTrigger on Training_Course__c (
    before insert, before update, before delete,
    after insert, after update, after delete, after undelete
) {
    new TrainingCourseHandler().execute();
}