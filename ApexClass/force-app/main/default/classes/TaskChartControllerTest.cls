@isTest
public with sharing class TaskChartControllerTest {
  @TestSetup
  static void makeData() {
    // Create Multiple Task with different Subject and statuses
    List<Task> multipleTask;
    String[] subjects;
    String[] statuses;
    multipleTask = new List<Task>();
    subjects = new List<String>{ 'Call', 'Email', 'Other' };
    statuses = new List<String>{ 'Not Started', 'Completed', 'In Progress' };

    for (Integer i = 0; i < 10; i++) {
      Task singleTask;
      singleTask = new Task();
      singleTask.Subject = subjects[Math.mod(i, subjects.size())];
      singleTask.Status = statuses[Math.mod(i, statuses.size())];
      multipleTask.add(singleTask);
    }
    insert multipleTask;
  }

  @isTest
  static void getTotalTaskCountTest() {
    //Bring Data
    List<Task> taskData;
    taskData = [SELECT id FROM Task];

    // Execute Code
    Test.startTest();
    Integer taskCount;
    taskCount = TaskChartController.getTotalTaskCount();
    Test.stopTest();

    //Assert
    Assert.areEqual(10, taskCount, 'Number of Task Does not match');
  }

  @isTest
  static void getTotalTaskCountTest_noData() {
    // Delete All Task
    List<Task> allTaskToDelete;
    allTaskToDelete = [SELECT Id FROM Task];
    delete allTaskToDelete;

    // Execute Code
    test.startTest();
    Integer taskCount;
    taskCount = TaskChartController.getTotalTaskCount();
    test.stopTest();

    // Assert
    Assert.areEqual(0, taskCount, 'Number of Task Does not match');
  }
}
