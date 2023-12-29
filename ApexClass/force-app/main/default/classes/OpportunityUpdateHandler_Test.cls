@isTest
public with sharing class OpportunityUpdateHandler_Test {
  @isTest
  static void testProbabilityChangeToMoreThan10() {
    // Local Variables
    List<Opportunity> oppCreated;
    List<Task> createdTask;
    // Create an opportunity
    oppCreated = DataFactory.createOpportunity(1);

    // Update opportunity probability from 10 to more than 10
    Test.startTest();
    oppCreated[0].Probability = 20;
    update oppCreated;
    Test.stopTest();

    // Query if New Task is created
    createdTask = [
      SELECT Id, WhatId
      FROM Task
      WHERE WhatId = :oppCreated[0].id
    ];

    // Assert The Result
    Assert.areEqual(
      1,
      createdTask.size(),
      'Created Number of task does not match.'
    );
  }
  @isTest
  static void testProbabilityOverrideMap() {
    // Local Variables
    List<Opportunity> testOpps;
    List<Task> createdTask;

    // Setup create opportunity probability rather than 10
    testOpps = DataFactory.createOpportunity(1); // This opportunity comes with probablity = 10. We need to change it for our test
    testOpps[0].Probability = 5;
    update testOpps; // this update does not create task

    // First Update
    testOpps[0].Probability = 10;
    update testOpps;

    //Second Update
    Test.startTest();
    testOpps[0].Probability = 20; //This will create task because previous probability 10 and next one more than 10
    update testOpps;
    Test.stopTest();

    // Query Task
    createdTask = [SELECT Id, WhatId FROM Task WHERE WhatId = :testOpps[0].id];

    // Assert
    Assert.areEqual(
      1,
      createdTask.size(),
      'Unexpected number of Tasks are created.'
    );
  }
}
