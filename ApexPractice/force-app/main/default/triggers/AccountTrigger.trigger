trigger AccountTrigger on Account(before insert, before update) {
  // Local Variables
  AccountTestCheckbox handler;
  Global_Trigger_Manager__mdt triggerSettings;

  // Retrieve Custom metadata
  triggerSettings = Global_Trigger_Manager__mdt.getInstance(
    'GlobalTriggerSwitch'
  );

  // Instantiate the handler class with Trigger.new
  handler = new AccountTestCheckbox(Trigger.new);

  if (triggerSettings != null && triggerSettings.Disable_All_Triggers__c) {
    return; // exit the trigger without further executin nothing returns.
  }

  if (Trigger.isBefore) {
    if (Trigger.isInsert) {
      handler.handleInsert();
    }
    if (Trigger.isUpdate) {
      handler.handleUpdate();
    }
  }

}
