trigger AccountTrigger on Account(before insert, before update) {
  if (Trigger.isBefore) {
    if (Trigger.isInsert) {
      AccountTestCheckbox.setCheckboxOnInsert(Trigger.new);
    }
    if (Trigger.isUpdate) {
      AccountTestCheckbox.setCheckboxOnUpdate(Trigger.New);
    }
  }

}
