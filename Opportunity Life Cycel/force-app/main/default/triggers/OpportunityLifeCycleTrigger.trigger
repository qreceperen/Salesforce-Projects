trigger OpportunityLifeCycleTrigger on Opportunity(after insert, after update) {
  // When new opportunity is added
  if (Trigger.isAfter) {
    if (Trigger.isInsert) {
      OpportunityLifecycleTriggerHandler.handleAfterInsert(Trigger.new);
    }

    if (Trigger.isUpdate) {
      OpportunityLifecycleTriggerHandler.handleUpdate(
        Trigger.new,
        Trigger.oldMap
      );
    }
  }
}
