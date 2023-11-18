@isTest
public with sharing class OpportunityLifecycleTriggerHandler_Test {
  @isTest
  static void handleInsert_AddSingleOpportunity() {
    // Local Variables
    Opportunity singleOpp;
    List<Task> taskList;
    // Data
    singleOpp = new Opportunity(
      Name = 'Test Single Opportunity',
      StageName = 'Prospecting',
      CloseDate = system.date.today().addDays(30)
    );
    insert singleOpp;

    //Assert
    //Inserting single Opp should run the trigger and trigger call OpportunityLifecycleTriggerHandler class and a task created.
    taskList = [SELECT id, Subject FROM Task];
    Assert.areEqual(
      1,
      taskList.size(),
      'Correct number of task is not created.'
    );

    Assert.areEqual(
      'New Opportunity is created Named Test Single Opportunity',
      taskList[0].Subject,
      'Created Task Subject name does not match'
    );
  }
  @isTest
  static void handleInsert_BulkOpportunity() {
    // Local Variables
    List<Opportunity> multiOpp;
    List<Task> taskList;
    // Data

    multiOpp = new List<Opportunity>();
    for (Integer i = 0; i < 1000; i++) {
      Opportunity singleOpp = new Opportunity(
        Name = 'Test Single Opportunity' + i,
        StageName = 'Prospecting',
        CloseDate = system.date.today().addDays(30)
      );
      multiOpp.add(singleOpp);
    }
    insert multiOpp;

    // Assert

    taskList = [SELECT id FROM Task];
    Assert.areEqual(1000, taskList.size(), 'Number of task is not correct');
  }

  @isTest
  static void handleStageChangeTest_UpdateStageSingleOpportunity() {
    // Local Variables
    Opportunity singleOpp;
    Opportunity returnedOpp;
    List<Task> taskList;
    String expectedDescription;

    // Data
    // Add an Opportunity
    singleOpp = new Opportunity(
      Name = 'Test 1',
      StageName = 'Prospecting',
      CloseDate = system.date.today().addDays(30)
    );
    insert singleOpp;
    //Delete all added Task
    taskList = [SELECT Id FROM Task];
    delete taskList;

    //Update Opportunity to Run Trigger
    returnedOpp = [
      SELECT Id, StageName
      FROM Opportunity
      WHERE Id = :singleOpp.id
      LIMIT 1
    ];

    returnedOpp.StageName = 'Qualification';
    update returnedOpp;

    // Assert Task Created
    taskList = [SELECT Id, Subject, Description FROM Task];
    Assert.isTrue(taskList.size() > 0, 'No task is added');
    Assert.areNotEqual(
      null,
      taskList[0].Description,
      'Task Description is NULL'
    );

    // expectedDescription = 'Stage is changed from Prospecting ---> To Qualification';
    // Assert.areEqual(
    //   expectedDescription,
    //   taskList[0].Description,
    //   'Description does not match expected content'
    // );
  }
}
