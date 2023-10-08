trigger LeadTrigger on Lead(after insert, after update) {
  if (TriggerRecursionControl.isLeadTriggerExecuted) {
    return; // Exit early if the trigger has already been executed
  }

  TriggerRecursionControl.isLeadTriggerExecuted = true; // Set the flag to prevent recursion

  LeadTriggerHandler handler = new LeadTriggerHandler();
  handler.handle(Trigger.new);
}
