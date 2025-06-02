trigger LeadTrigger on Lead (before insert, before update) {
    if(Trigger.isInsert || Trigger.isUpdate){
        TriggerHandler.handleTrigger(Trigger.New);
    }
}