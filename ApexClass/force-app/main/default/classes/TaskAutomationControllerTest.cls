@isTest
public with sharing class TaskAutomationControllerTest {
  @TestSetup
  static void makeData() {
    // Add three Task which Due date passed
    List<Task> dueDatePassedTasks;
    Date today;
    today = Date.today();
    dueDatePassedTasks = new List<Task>();

    for (Integer i = 1; i < 4; i++) {
      Task overDueTask;
      overDueTask = new Task();
      overDueTask.Status = 'Not Started';
      overDueTask.ActivityDate = today - i;
      overDueTask.Subject = 'Other';
      overDueTask.Priority = 'Normal';
      dueDatePassedTasks.add(overDueTask);
    }
    insert dueDatePassedTasks;
  }

  @isTest
  static void taskToUpdateOverDueTasks() {
    // OverDue Tasks status will be completed
    // Call Tasks
    List<Task> overDueTasks = [
      SELECT id, Status, ActivityDate
      FROM TASK
      WHERE Status = 'Not Started'
    ];

    // Collect the Ids of OverDue Task
    Set<Id> overDueTaskIds;
    overDueTaskIds = new Set<Id>();
    for (Task t : overDueTasks) {
      overDueTaskIds.add(t.id);
    }

    // Execute method (overDueTask Status should be completed)
    Test.startTest();
    TaskAutomationController.updateTaskStatus(overDueTasks);
    Test.stopTest();

    // Re-Query the tasks with their ids
    List<Task> updatedTasks;
    updatedTasks = [SELECT Id, Status FROM Task WHERE Id IN :overDueTaskIds];

    // Assert
    for (Task updatedTask : updatedTasks) {
      Assert.areEqual(
        'Completed',
        updatedTask.Status,
        'Status should be updated to Completed'
      );
    }
  }
}
