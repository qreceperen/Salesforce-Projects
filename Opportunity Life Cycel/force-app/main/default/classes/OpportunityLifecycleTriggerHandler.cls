public with sharing class OpportunityLifecycleTriggerHandler {
  public static void handleInsert(List<Opportunity> triggerNew) {
    List<Task> taskList;

    taskList = new List<Task>();
    for (Opportunity opp : triggerNew) {
      Task task = new Task(
        Subject = 'New Opportunity is created Named ' + opp.Name,
        Priority = 'Normal',
        OwnerId = opp.OwnerId,
        WhatId = opp.id
      );
      taskList.add(task);
    }
    try {
      insert taskList;
    } catch (Exception e) {
      system.debug('ERROR ' + e.getMessage());
    }
  }
}
