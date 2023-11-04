trigger ApexErrorEventTrigger on ApexErrorEvent__e(after insert) {
  ApexErrorEventTriggerHandler.handleAfterInsert(Trigger.new);

}
