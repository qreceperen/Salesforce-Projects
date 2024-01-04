trigger AccountTrigger on Account(before insert, before update) {
  // Retrieve Custom metadata
  Global_Trigger_Manager__mdt triggerSettings = Global_Trigger_Manager__mdt.getInstance(
    'GlobalTriggerSwitch'
  );

  if (triggerSettings != null && triggerSettings.Disable_All_Triggers__c) {
    return; // exit the trigger without further executin nothing returns.
  }

  if (Trigger.isBefore) {
    if (Trigger.isInsert) {
      AccountTestCheckbox.setCheckboxOnInsert(Trigger.new);
    }
    if (Trigger.isUpdate) {
      AccountTestCheckbox.setCheckboxOnUpdate(Trigger.New);
    }
  }

}
