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
}
