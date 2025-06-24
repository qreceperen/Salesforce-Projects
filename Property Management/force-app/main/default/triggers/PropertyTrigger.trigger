trigger PropertyTrigger on Property__c(
  before insert,
  before update,
  after insert,
  after update
) {
  // Step 1: Framework logic
  TriggerContext.clearInstance(); // 🔧 Reset singleton
  new PropertyTriggerHandler().execute();
}
