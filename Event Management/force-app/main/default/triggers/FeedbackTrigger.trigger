trigger FeedbackTrigger on Feedback__c (before insert) {

    if (Trigger.isBefore && Trigger.isInsert) {
        // Step 1: Collect Related Event_Registration__c IDs
        Set<Id> eventRegistrationIds = new Set<Id>();
        for (Feedback__c feedback : Trigger.New) {
            if (feedback.Event_Registration__c == null) {
                feedback.addError('You cannot add a feedback without related Event Custom Record');
            } else {
                eventRegistrationIds.add(feedback.Event_Registration__c);

            }
        }
            // Step 2: Query Related Event_Registration__c records
            Map<Id, Event_Registration__c> eventRegistrationMap = new Map<Id, Event_Registration__c>(
                [SELECT Id, Registration_Status__c 
                 FROM Event_Registration__c 
                 WHERE Id IN :eventRegistrationIds]
            );

            // Step 3: Validate Feedback__c records
            for (Feedback__c feedback : Trigger.New) {
                Event_Registration__c relatedRegistration = eventRegistrationMap.get(feedback.Event_Registration__c);

                if (relatedRegistration == null || relatedRegistration.Registration_Status__c != 'Registered') {
                    feedback.addError('Feedback can only be submitted for registered attendees.');
                }
                
            }
        
    }
}
