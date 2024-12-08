public with sharing class EventFeedbackWrapper {
    @AuraEnabled public String eventName;
    @AuraEnabled public Decimal averageRating;
    @AuraEnabled public List<Feedback__c> eventRelatedFeedbacks;

    
    public EventFeedbackWrapper(Id eventCustomId) {
        // Query Event_Custom__c record
        Event_Custom__c eventCustom = [
            SELECT Id, Name, Average_Feedback_Score__c 
            FROM Event_Custom__c 
            WHERE Id = :eventCustomId 
            LIMIT 1
        ];

        if (eventCustom == null) { // Defensive check
            throw new IllegalArgumentException('No Event_Custom__c found for the given Id: ' + eventCustomId);
        }

        this.eventName = eventCustom.Name;
        this.averageRating = eventCustom.Average_Feedback_Score__c;
        // Get related feedback
        this.eventRelatedFeedbacks = getFeedback(eventCustomId);
    }


    @AuraEnabled(cacheable=true)
    public static EventFeedbackWrapper getEventFeedbackDetails(Id eventCustomId) {
        return new EventFeedbackWrapper(eventCustomId);
    }

    private List<Feedback__c> getFeedback(Id eventCustomId) {
        // Query Event_Registration__c records
        List<Event_Registration__c> eventRegistrations = [
            SELECT Id 
            FROM Event_Registration__c 
            WHERE Event_Custom__c = :eventCustomId
        ];

        if (eventRegistrations.isEmpty()) { // Defensive check
            return new List<Feedback__c>(); // Return empty list if no registrations exist
        }

        // Collect Event_Registration__c IDs
        Set<Id> eventRegistrationIds = new Set<Id>();
        for (Event_Registration__c er : eventRegistrations) {
            eventRegistrationIds.add(er.Id);
        }

        // Query Feedback__c records
        return [
            SELECT Id, Feedback_Text__c, Rating__c, Submitted_Date__c 
            FROM Feedback__c 
            WHERE Event_Registration__c IN :eventRegistrationIds
        ];
    }
}
