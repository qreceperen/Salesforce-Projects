trigger UnitTrigger on Unit__c (before insert, before update, after insert, after delete, after undelete, after update) {

    TriggerContext.clearInstance(); // 🔧 Reset singleton
    new UnitTriggerHandler().execute();

}
