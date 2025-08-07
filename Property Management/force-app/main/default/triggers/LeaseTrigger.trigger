trigger LeaseTrigger on Lease__c (
    before insert, before update,
    after insert, after update, after delete
) {
    TriggerContext.clearInstance();
    new LeaseTriggerHandler().execute();
}
