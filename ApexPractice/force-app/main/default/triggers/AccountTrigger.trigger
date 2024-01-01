trigger AccountTrigger on Account(before insert) {
  if (Trigger.isBefore && Trigger.isInsert) {
    AccountTestCheckbox.updateCheckboxBasedOnName(Trigger.new);
  }

}
