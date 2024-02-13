trigger taskTrigger on task(before insert, before update) {
  if (Trigger.isBefore && Trigger.isInsert) {
    taskTriggerHandler.beforeInsert(Trigger.New);
}

if (Trigger.isBefore && Trigger.isUpdate) {
      taskTriggerHandler.beforeUpdate(Trigger.New, Trigger.OldMap);

    // Task oldTask = Trigger.oldMap.get(Trigger.New[0].id);
    // Task newTask = Trigger.new[0];
    // system.debug('Old Description '+ oldTask.Description);
    // system.debug('New Destription '+ newTask.Description);

    // if (newTask.Description != oldTask.Description) {
    //     newTask.ShortMessage__c = newTask.Description.length() > 100
    //     ? newTask.Description.substring(0,100)
    //     : newTask.Description;
    //     system.Debug('They are equalllll');
        
    // } else {
    //     // newTask.ShortMessage__c = newTask.Description.length() > 100
    //     // ? newTask.Description.substring(0,100)
    //     // : newTask.Description;
    //     system.debug('They are not equalll');
    // }


  }
}
