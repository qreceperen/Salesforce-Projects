trigger ContactTrigger on Contact (before insert, before update) {

    if(Trigger.isBefore && Trigger.isInsert){
            contactTriggerHandler.insertContactHandle(Trigger.New);
    }

    if(Trigger.isBefore && Trigger.isUpdate){
        contactTriggerHandler.updateContactHandle(Trigger.New, Trigger.oldMap);
    }
}