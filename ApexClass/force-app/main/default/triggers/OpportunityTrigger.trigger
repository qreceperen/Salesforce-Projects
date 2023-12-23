trigger OpportunityTrigger on Opportunity(after update) {
  if (Trigger.isAfter & Trigger.isUpdate) {
    OpportunityUpdateHandler.handleProbabilityChange(
      Trigger.oldMap,
      Trigger.newMap,
      Trigger.new
    );
  }

}
