trigger OpportunityLifecycleTrigger on Opportunity(after insert) {
  if (Trigger.isAfter && Trigger.isInsert) {
    List<Task> taskList;

    taskList = new List<Task>();
    for (Opportunity opp : Trigger.new) {
      Task singleTask = new Task(
        Subject = 'New Opportunity Created: ' + opp.Name,
        WhatId = opp.id,
        OwnerId = opp.OwnerId
      );
      taskList.add(singleTask);
    }
    insert taskList;
  }

}
