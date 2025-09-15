/**
 * Trigger handler for Training_Enrollment__c object
 */
public class TrainingEnrollmentHandler extends TriggerHandler {
    // Active enrollment statuses that count toward capacity
    private static final Set<String> ACTIVE_STATUSES = new Set<String>{'Enrolled', 'In Progress'};
    
    /**
     * Before Insert logic
     */
    protected override void beforeInsert() {
        System.debug('TrainingEnrollmentHandler: Before Insert');
        validateEnrollmentCapacity(Trigger.new, null);
    }
    
    /**
     * Before Update logic
     */
    protected override void beforeUpdate() {
        System.debug('TrainingEnrollmentHandler: Before Update');
        // Future business logic will go here
    }
    
    /**
     * After Insert logic
     */
    protected override void afterInsert() {
        System.debug('TrainingEnrollmentHandler: After Insert');
        // Future business logic will go here
    }
    
    /**
     * After Update logic
     */
    protected override void afterUpdate() {
        System.debug('TrainingEnrollmentHandler: After Update');
        // Future business logic will go here
    }
    
    /**
     * After Delete logic
     */
    protected override void afterDelete() {
        System.debug('TrainingEnrollmentHandler: After Delete');
        // Future business logic will go here
    }

    // Validates that enrollment does not exceed the capacity of the training 
    private void validateEnrollmentCapacity(List<Training_Enrollment__c> newEnrollments, Map<Id, Training_Enrollment__c> oldEnrollments) {
        // Collect course IDs that need capacity validation
        Set<Id>courseIds = new Set<Id>();

        for(Training_Enrollment__c enrollment : newEnrollments) {
            if(ACTIVE_STATUSES.contains(enrollment.Status__c))
                courseIds.add(enrollment.Training_Course__c);
        }
    }
}