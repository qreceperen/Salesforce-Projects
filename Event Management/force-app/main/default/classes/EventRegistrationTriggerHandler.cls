public with sharing class EventRegistrationTriggerHandler {

public static void validateSeatAvailability(List<Event_Registration__c> eventRegisters) {
    // Step 1: Collect Event_Custom__c IDs
    Set<Id> eventCustomIds = new Set<Id>();
    for (Event_Registration__c eventRegister : eventRegisters) {
        if (eventRegister.Event_Custom__c != null) {
            eventCustomIds.add(eventRegister.Event_Custom__c);
        } else {
            eventRegister.addError('The associated event does not exist.');
        }
    }

    // Step 2: Query Event_Custom__c records in bulk
    Map<Id, Event_Custom__c> eventCustomMap = getEventCustomMap(eventCustomIds);

    // Step 3: Validate seat availability and prepare updates
    List<Event_Custom__c> updateEventCustoms = new List<Event_Custom__c>();
    for (Event_Registration__c eventRegister : eventRegisters) {
        if (eventRegister.Event_Custom__c == null) continue;

        // Get Related Event_Custom__c record
        Event_Custom__c relatedEvent = eventCustomMap.get(eventRegister.Event_Custom__c);

        // Check if related event exists
        if (relatedEvent == null) {
            eventRegister.addError('The associated event does not exist.');
            continue;
        }

        // Check Seat Availability
        if (relatedEvent.Available_Seats__c != null && relatedEvent.Available_Seats__c > 0) {
            // Prepare Event_Custom__c record for update
            Event_Custom__c updateEventCustom = new Event_Custom__c();
            updateEventCustom.Id = relatedEvent.Id;
            updateEventCustom.Seats_Filled__c = relatedEvent.Seats_Filled__c + 1;
            updateEventCustoms.add(updateEventCustom);
        } else {
            eventRegister.addError('No seats left for the event: ' + relatedEvent.Name);
        }
    }

    // Step 4: Handle Updates if there are changes
    if (!updateEventCustoms.isEmpty()) {
        try {
            update updateEventCustoms;
        } catch (Exception ex) {
            System.debug('Error updating Event_Custom__c records: ' + ex.getMessage());
        }
    }
}

    public static void handleEventRegisterName(List<Event_Registration__c> eventRegisters){
        Set<Id> eventCustomIds = new Set<Id>();
        
        for(Event_Registration__c eventRegister : eventRegisters){
            if(eventRegister.Event_Custom__c != null){
                eventCustomIds.add(eventRegister.Event_Custom__c);
            }
        }
        //Custom Event Names
        Map<Id, Event_Custom__c> eventCustomMap = getEventCustomMap(eventCustomIds);

        for(Event_Registration__c eventRegister : eventRegisters){
            if(eventRegister.Event_Custom__c != null && eventCustomMap.containsKey(eventRegister.Event_Custom__c)){
                String eventName = eventCustomMap.get(eventRegister.Event_Custom__c).Name;
                eventRegister.Name = eventName + ' - ' + (eventRegister.Attendee_Name__c != null ? eventRegister.Attendee_Name__c : 'Unnamed Attendee');
            } else {
                // Handle cases where Event Custom is null
                eventRegister.name = 'Unkown Event - ' + (eventRegister.Attendee_Name__c != null ? eventRegister.Attendee_Name__c : 'Unnamed Attendee');
            }
        }
    }

    private static Map<Id, Event_Custom__c> getEventCustomMap(Set<Id> eventCustomIds){
        // Return an Empty Map if no IDs are provided
        if(eventCustomIds == null || eventCustomIds.isEmpty()){
            return new Map<Id, Event_Custom__c>();
        }
        
        return new Map<Id, Event_Custom__c>([SELECT Id, Name, Seats_Filled__c, Available_Seats__c FROM Event_Custom__c WHERE Id IN :eventCustomIds]);
    }
}
