public with sharing class taskTriggerHandler {
  public static void beforeInsert(List<Task> tasks) {
    processTasks(tasks);
  }

  public static void beforeUpdate(
    List<Task> newTasks,
    Map<Id, Task> oldTaskMap
  ) {
    Task newTask = newTasks[0];
    Task oldTask = oldTaskMap.get(newTask.id);

    system.debug('Old Desc' + newTask.Description);
    system.debug('New Desc' + oldTask.Description);

    // List<Task> tasksToProcess = new List<Task>();
    // for (Task newTask : newTasks) {
    //   Task oldTask = oldTaskMap.get(newTask.Id);

    //   if (newTask.Description != oldTask.Description) {
    //     tasksToProcess.add(newTask);
    //   }
    // }
    // if(!tasksToProcess.isEmpty()) {
    //     processTasks(tasksToProcess);

    // }
  }
  private static void processTasks(List<Task> tasks) {
    for (Task t : tasks) {
      if (String.isNotBlank(t.Description)) {
        t.ShortMessage__c = t.Description.length() > 100
          ? t.Description.substring(0, 100)
          : t.Description;
      } else {
        t.ShortMessage__c = '';
      }
    }
  }
}
