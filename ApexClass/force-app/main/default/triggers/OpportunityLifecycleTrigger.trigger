trigger OpportunityLifecycleTrigger on Opportunity(after insert) {
  if (Trigger.isInsert) {
    if (Trigger.isAfter) {
      OpportunityLifecycleTriggerHandler.handleAfterInsert(Trigger.New);
    }
  }

}
