public with sharing class OpportunityLifecycleTriggerHandler {
  public static void handleAfterInsert(List<Opportunity> triggerNew) {
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

  public static void handleStageChange(
    List<Opportunity> TriggerNew,
    Map<Id, Opportunity> TriggerOldMap
  ) {
    // Local Variables
    List<Task> taskList;

    taskList = new List<Task>();
    for (Opportunity opp : TriggerNew) {
      String oppOldStage;
      String oppNewStage;

      oppOldStage = TriggerOldMap.get(opp.id).StageName;
      oppNewStage = opp.StageName;

      if ((!oppOldStage.equals(oppNewStage))) {
        Task task = new Task(
          Subject = opp.Name + ' Stage is Changed',
          Description = 'Stage changed from ' +
            oppOldStage +
            '---> To ' +
            oppNewStage,
          Priority = 'Normal',
          OwnerId = opp.OwnerId,
          WhatId = opp.id
        );
        taskList.add(task);
      }
    }
    try {
      insert taskList;
    } catch (Exception e) {
      system.debug('ERROR WHILE INSERTING TASK LIST ' + e.getMessage());
    }
  }
}
