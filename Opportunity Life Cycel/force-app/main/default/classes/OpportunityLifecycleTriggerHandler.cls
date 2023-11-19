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

  public static void handleUpdate(
    List<Opportunity> triggerNew,
    Map<Id, Opportunity> triggerOldMap
  ) {
    List<Opportunity> oppsWithStageChange;
    List<Opportunity> oppsWithAmountChange;

    // After Update includes Update
    oppsWithStageChange = new List<Opportunity>();
    oppsWithAmountChange = new List<Opportunity>();
    for (Opportunity opp : triggerNew) {
      // Create List of Opportunity for Stage Change;
      if (!opp.StageName.equals(triggerOldMap.get(opp.id).StageName)) {
        oppsWithStageChange.add(opp);
      }

      // Create List of Opportunity for Amount Change
      if (opp.Amount != triggerOldMap.get(opp.id).Amount) {
        oppsWithAmountChange.add(opp);
      }

      // Update Opportunity with Stage Changed
      if (!oppsWithStageChange.isEmpty()) {
        OpportunityLifecycleTriggerHandler.handleStageChange(
          oppsWithStageChange,
          triggerOldMap
        );
      }
      if (!oppsWithAmountChange.isEmpty()) {
        OpportunityLifecycleTriggerHandler.handleAmountChange(
          oppsWithAmountChange,
          triggerOldMap
        );
      }
    }
  }
  public static void handleStageChange(
    List<Opportunity> oppsStageChanged,
    Map<Id, Opportunity> triggerOldMap
  ) {
    // Local Variables
    List<Task> taskList;

    taskList = new List<Task>();
    for (Opportunity opp : oppsStageChanged) {
      String oppOldStage = triggerOldMap.get(opp.id).StageName;
      String oppNewStage = opp.StageName;

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
    if (!taskList.isEmpty()) {
      try {
        insert taskList;
      } catch (Exception e) {
        system.debug('ERROR WHILE INSERTING TASK LIST ' + e.getMessage());
      }
    }
  }

  public static void handleAmountChange(
    List<Opportunity> oppsWithAmountChange,
    Map<Id, Opportunity> triggerOldMap
  ) {
    // Local Variables
    List<Task> taskList;

    taskList = new List<Task>();
    for (Opportunity opp : oppsWithAmountChange) {
      Decimal oppOldAmount = triggerOldMap.get(opp.id).Amount;
      Decimal oppNewAmount = opp.Amount;
      Task task = new Task(
        Subject = opp.Name + ' Amount is Changed',
        Description = 'Amount changed from $' +
          oppOldAmount +
          '---> To $' +
          oppNewAmount +
          'on Date ' +
          DateTime.now(),
        Priority = 'Normal',
        OwnerId = opp.OwnerId,
        WhatId = opp.id
      );
      taskList.add(task);
    }
    if (!taskList.isEmpty()) {
      try {
        insert taskList;
      } catch (Exception e) {
        system.debug('ERROR WHILE INSERTING TASK LIST ' + e.getMessage());
      }
    }
  }
}
