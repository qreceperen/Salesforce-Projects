trigger OpportunityLifeCycleTrigger on Opportunity(after insert, after update) {
  if (Trigger.isAfter && Trigger.isInsert) {
    OpportunityLifecycleTriggerHandler.handleAfterInsert(Trigger.new);
  }

  if (Trigger.isAfter && Trigger.isUpdate) {
    OpportunityLifecycleTriggerHandler.handleStageChange(
      Trigger.new,
      Trigger.oldMap
    );
  }
}
