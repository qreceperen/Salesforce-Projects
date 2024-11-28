trigger EventRegistrationTrigger on Event_Registration__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        Set<Id> eventCustomIds = new Set<Id>();
        
        for(Event_Registration__c eventRegister : Trigger.New){
            if(eventRegister.Event_Custom__c != null){
                eventCustomIds.add(eventRegister.Event_Custom__c);
            }
        }
        //Custom Event Names
        Map<Id, Event_Custom__c> eventCustomMap = new Map<Id,Event_Custom__c>([SELECT Id, Name FROM Event_Custom__c WHERE Id IN:eventCustomIds]);

        for(Event_Registration__c eventRegister : Trigger.New){
            if(eventRegister.Event_Custom__c != null && eventCustomMap.containsKey(eventRegister.Event_Custom__c)){
                String eventName = eventCustomMap.get(eventRegister.Event_Custom__c).Name;
                eventRegister.Name = eventName + ' - ' + (eventRegister.Attendee_Name__c != null ? eventRegister.Attendee_Name__c : 'Unnamed Attendee');
            } else {
                // Handle cases where Event Custom is null
                eventRegister.name = 'Unkown Event - ' + (eventRegister.Attendee_Name__c != null ? eventRegister.Attendee_Name__c : 'Unnamed Attendee');
            }
        }
    }
}