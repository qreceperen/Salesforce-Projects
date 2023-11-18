trigger OpportunityLifeCycleTrigger on Opportunity(after insert, after update) {
  if (Trigger.isAfter && Trigger.isInsert) {
    OpportunityLifecycleTriggerHandler.handleAfterInsert(Trigger.new);
  }

  if (Trigger.isAfter && Trigger.isUpdate) {
    // Local Variables
    List<Opportunity> 
    for (Opportunity opp : Trigger.New) {
      // Call Handler if Opportunity stage is changed;
      if (!opp.StageName.equals(Trigger.oldMap.get(opp.id).StageName)) {
        OpportunityLifecycleTriggerHandler.handleStageChange(
          Trigger.new,
          Trigger.oldMap
        );
      }
    }
  }
}
