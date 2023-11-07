@isTest
public with sharing class ErrorLogTest {
  @isTest
  static void createErrorSingleTest() {
    // Local Variables
    Account account;
    List<Error_Log__c> errorLogs;

    // Try to create an error
    account = new Account();
    try {
      insert account;
    } catch (Exception e) {
      Test.startTest();
      ErrorLog.logError('ErrorLogTest', 'createError', e);
      Test.stopTest();

      //Assertation
      errorLogs = [SELECT Id FROM Error_Log__c];
      Assert.areEqual(1, errorLogs.size(), 'Error Log is not created.');
    }
  }
  @isTest
  static void createErrorBulkTest() {
    // Initialize the list
    List<Account> accountList = new List<Account>();

    // Create account List to Insert
    for (Integer i = 0; i < 10; i++) {
      Account singleAccount = new Account();
      accountList.add(singleAccount);
    }

    // Use Database.insert for partial success and collect errors
    Test.startTest();
    Database.SaveResult[] saveResults = Database.insert(accountList, false);
    for (Database.SaveResult result : saveResults) {
      if (!result.isSuccess()) {
        // Simulate a DML exception for the failed operation
        DmlException dmlEx = new DmlException();
        // Mock the error message (in real scenarios, you get it from result.getErrors())
        dmlEx.setMessage('Required fields are missing: [Name]');
        ErrorLog.logError('ErrorLogTest', 'createErrorBulkTest', dmlEx);
      }
    }

    Test.stopTest();

    // Assert
    List<Error_Log__c> errorLogs = [SELECT Id FROM Error_Log__c];
    System.assertEquals(
      10,
      errorLogs.size(),
      'Bulk Error Logs are not created'
    );
  }
}
