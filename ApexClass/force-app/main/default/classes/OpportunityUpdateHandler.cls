public with sharing class OpportunityUpdateHandler {
  private static Map<Id, Double> probabilityOverrides = new Map<Id, Double>();

  public static void handleProbabilityChange(
    Map<Id, Opportunity> oldMap,
    Map<Id, Opportunity> newMap,
    List<Opportunity> newList
  ) {
    // Local variables
    Opportunity oldOpp;
    List<Task> tasksToCreate;
    Double oldProbability;
    // Check if opportunity Probability is updated

    tasksToCreate = new List<Task>();
    for (Opportunity newOpp : newList) {
      oldOpp = oldMap.get(newOpp.id);
      oldProbability = probabilityOverrides.containsKey(newOpp.id)
        ? probabilityOverrides.get(newOpp.Id)
        : oldOpp.Probability;

      //   Compare oldOpp and newOpp if update is happened
      if (oldProbability == 10 && newOpp.Probability > 10) {
        // Create a New Task

        Task newTask = new Task(
          ownerId = newOpp.OwnerId,
          WhatId = newOpp.Id,
          ActivityDate = Date.today().addDays(2),
          Subject = 'Opportunity Stage update',
          Type = 'Other'
        );
        tasksToCreate.add(newTask);
      }
      // Update the map with the latest Probability
      probabilityOverrides.put(newOpp.id, newOpp.Probability);
    }
    // Insert Task
    if (!tasksToCreate.isEmpty()) {
      insert tasksToCreate;
    }
  }
}
