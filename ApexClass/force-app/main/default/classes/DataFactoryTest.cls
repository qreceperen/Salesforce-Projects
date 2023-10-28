@isTest
public with sharing class DataFactoryTest {
  @isTest
  static void createOpportunity_insertSingleOppTest() {
    List<Opportunity> dataBaseOpp;

    // No Opportunity first

    // Execute Code
    Test.startTest();
    DataFactory.createOpportunity(1);
    Test.stopTest();

    // Assert
    dataBaseOpp = [SELECT Id FROM Opportunity];
    Assert.areEqual(
      1,
      dataBaseOpp.size(),
      'Unexpected number of Opportunity created'
    );
  }
  @isTest
  static void createOpportunity_insertMultiOppTest() {
    List<Opportunity> dataBaseOpp;
    Date after30Day;

    // Data Base Empty

    // Execute
    Test.startTest();
    DataFactory.createOpportunity(10);
    Test.stopTest();

    // Assert

    // Assert size of opp added to database
    dataBaseOpp = [SELECT Id, CloseDate FROM Opportunity];
    Assert.areEqual(
      10,
      dataBaseOpp.size(),
      'Unexpected number of Opportunity created'
    );

    // Assert Date match
    after30Day = date.today().addDays(30);
    for (Opportunity opp : dataBaseOpp) {
      Assert.areEqual(
        after30Day,
        opp.CloseDate,
        'Close date is not as Expected'
      );
    }
  }
}
