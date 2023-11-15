trigger OpportunityLifeCycleTrigger on Opportunity(after insert) {
  if (Trigger.isAfter && Trigger.isInsert) {
    OpportunityLifecycleTriggerHandler.handleInsert(Trigger.new);
  }
}
