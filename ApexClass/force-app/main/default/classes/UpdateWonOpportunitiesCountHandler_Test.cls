@isTest
public with sharing class UpdateWonOpportunitiesCountHandler_Test {
  @TestSetup
  static void makeData() {
    Account accWithTwoClosedWonOpp;
    List<Opportunity> twoOppWithClosedWonStage;

    // Add an Account and Related Opportunity
    accWithTwoClosedWonOpp = new Account();
    accWithTwoClosedWonOpp.Name = 'Test Account-1';
    insert accWithTwoClosedWonOpp;
    // Two Opportunity with Stage = 'Closed Won'
    twoOppWithClosedWonStage = new List<Opportunity>();
    for (Integer i = 0; i < 2; i++) {
      Opportunity opp;
      opp = new Opportunity();
      opp.Name = 'Test Opp-' + i;
      opp.StageName = 'Closed Won';
      opp.CloseDate = Date.today() + 30;
      opp.Accountid = accWithTwoClosedWonOpp.id;
      twoOppWithClosedWonStage.add(opp);
    }
    insert twoOppWithClosedWonStage;
  }

  @isTest
  static void handleInsertUpdate_accWithOpp_Test() {
    // Bring Data
    Account acc;
    Opportunity opp;

    acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account-1' LIMIT 1];
    opp = [
      SELECT Id, AccountId, Name
      FROM Opportunity
      WHERE AccountId = :acc.id
      LIMIT 1
    ];

    Test.startTest();
    opp.Name = 'Name is updated';
    update opp;
    Test.stopTest();

    //Assert
    Account accRetrieved;
    accRetrieved = [
      SELECT Id, Name, NumberOfWonOpportunities__c
      FROM Account
      WHERE Id = :acc.id
    ];
  }

  @isTest
  static void handleDelete_DeleteOneOppFromRelatedAcc_Test() {
    // Bring Data
    Account acc;
    Opportunity opp;

    acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account-1' LIMIT 1];
    opp = [
      SELECT Id, AccountId, Name
      FROM Opportunity
      WHERE AccountId = :acc.id
      LIMIT 1
    ];

    // Execute Delete one Opp
    test.startTest();
    delete opp;
    test.stopTest();

    //Assert
    Account accRetrieved;
    accRetrieved = [
      SELECT Id, NumberOfWonOpportunities__c
      FROM Account
      WHERE Id = :acc.id
    ];
    Assert.areEqual(
      1,
      accRetrieved.NumberOfWonOpportunities__c,
      'Number of Won Opp Does not Match. Expected:1, Actual' +
      accRetrieved.NumberOfWonOpportunities__c
    );
  }
}
