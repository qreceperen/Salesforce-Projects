public with sharing class OpportunityLifecycleTriggerHandler {
  public static void handleAfterInsert(List<Opportunity> oppList) {
    List<Task> taskToInsert;
    Savepoint savePoint;

    taskToInsert = new List<Task>();
    for (Opportunity opp : oppList) {
      Task singleTask;
      singleTask = new Task();
      singleTask.Subject = 'New Opportunity Created:' + opp.Name;
      singleTask.Priority = 'Normal';
      singleTask.OwnerId = opp.OwnerId;
      singleTask.WhatId = opp.id;
      taskToInsert.add(singleTask);
    }

    savePoint = Database.setSavePoint();
    try {
      insert taskToInsert;
    } catch (Exception e) {
      system.debug(
        'Insert is failed returning to Save Point ' + e.getMessage()
      );
      Database.rollback(savePoint);
    }
  }
}
