trigger EventRegistrationTrigger on Event_Registration__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){

        EventRegistrationTriggerHandler.validateSeatAvailability(Trigger.New);
        // HANDLE EVENT REGISTER NAME
        EventRegistrationTriggerHandler.handleEventRegisterName(Trigger.New);
    }
}