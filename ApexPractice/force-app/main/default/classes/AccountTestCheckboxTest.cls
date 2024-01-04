@isTest
public with sharing class AccountTestCheckboxTest {
  @isTest
  static void positiveTest() {
    // Local Variables
    List<Account> accounts;
    Account retrievedAccount;

    // Setup test Data
    accounts = AccountTriggerFactory.createAccount(
      'Perform Apex Test Checkbox Test',
      false,
      1
    );

    // Execute
    Test.startTest();
    DMLUtils.doOperate(DMLUtils.DMLOperation.DO_INSERT, accounts); // TDD Test Fail Before Trigger
    Test.stopTest();

    // Retrieve Account
    retrievedAccount = [
      SELECT Test_Checkbox__c
      FROM Account
      WHERE Id = :accounts[0].id
      LIMIT 1
    ];

    // Assert
    Assert.areEqual(
      true,
      retrievedAccount.Test_Checkbox__c,
      'Checkbox should be true when Name is "Perform Test Checkbox Test" '
    );
  }
  @isTest
  static void negativeTest() {
    // Local Variables
    List<Account> accounts;
    Account retrievedAccount;

    // Setup Test Data
    accounts = AccountTriggerFactory.createAccount(
      'NOT Perform Apex Test Checkbox Test',
      false,
      1
    );

    // Execute
    Test.startTest();
    DMLUtils.doOperate(DMLUtils.DMLOperation.DO_INSERT, accounts);
    Test.stopTest();

    // Retrieve Account
    retrievedAccount = [
      SELECT Test_Checkbox__c
      FROM Account
      WHERE Id = :accounts[0].id
    ];

    // Assert
    Assert.areEqual(
      false,
      retrievedAccount.Test_Checkbox__c,
      'Checkbox should remain false for other names'
    );

    // TDD Approach: Initially, set the test to expect the opposite behavior
    // (e.g., expect the checkbox to be true) to ensure the test fails without any trigger logic.
    // This confirms that the functionality (keeping the checkbox unchanged for non-matching names) doesn't exist yet.
    // Uncomment the line below for the initial TDD failure scenario:

    /*
    Assert.areEqual(
      true,
      retrievedAcc.Test_Checkbox__c,
      'Expected checkbox to be true initially for TDD failure'
    );
    */
  }
  @isTest
  static void positiveBulkTest() {
    // Local Variables
    List<Account> accounts;
    List<Account> retrievedAccounts;
    Set<Id> accountIds;

    // Setup Test Data
    accounts = AccountTriggerFactory.createAccount(
      'Perform Apex Test Checkbox Test',
      false,
      200
    );

    // Execute
    Test.startTest();
    DMLUtils.doOperate(DMLUtils.DMLOperation.DO_INSERT, accounts); // TDD Test Fail before Trigger
    Test.stopTest();

    // Collect Unique Account Id to retrieve what you insert in only this test Method
    accountIds = new Set<Id>();
    for (Account acc : accounts) {
      accountIds.add(acc.id);
    }

    // Retrieve Data;
    retrievedAccounts = [
      SELECT Test_Checkbox__c
      FROM Account
      WHERE Id IN :accountIds AND Test_Checkbox__c = TRUE
    ];

    // Assert
    // There should be 200 Account returned within Test_Checkbox=true
    Assert.areEqual(
      200,
      retrievedAccounts.size(),
      '200 Accounts should be returned within Test Checbox = true but NOT'
    );
  }
  @isTest
  static void negativeBulkTest() {
    // Local Variables
    List<Account> accounts;
    List<Account> retrievedAccounts;
    Set<Id> accountIds;

    // Setup Test Data
    accounts = AccountTriggerFactory.createAccount(
      'NOT Perform Apex Test Checkbox Test',
      false,
      200
    );

    // Execute
    Test.startTest();
    DMLUtils.doOperate(DMLUtils.DMLOperation.DO_INSERT, accounts); // TDD Test Fail before Trigger
    Test.stopTest();

    // Collect Unique Account Id to retrieve what you insert in only this test Method
    accountIds = new Set<Id>();
    for (Account acc : accounts) {
      accountIds.add(acc.id);
    }

    // Retrieve Data;
    retrievedAccounts = [
      SELECT Test_Checkbox__c
      FROM Account
      WHERE Id IN :accountIds AND Test_Checkbox__c = FALSE
    ];

    // Assert
    // There should be 200 Account returned within Test_Checkbox=true
    Assert.areEqual(
      200,
      retrievedAccounts.size(),
      '200 Accounts should be returned within Test Checbox = false but NOT'
    );
  }
  @isTest
  static void positiveUpdateTest() {
    // Local Variables
    List<Account> accounts;
    Account retrievedAccount;

    // Setup test Data
    // Add Account that name is 'NOT Perform Apex Test Checkbox Test' and update to 'Perform Apex Test Checkbox Test'
    accounts = AccountTriggerFactory.createAccount(
      'NOT Perform Apex Test Checkbox Test',
      false,
      1
    );
    DMLUtils.doOperate(DMLUtils.DMLOperation.DO_INSERT, accounts);

    // Execute Update Account
    for (Account acc : accounts) {
      acc.name = 'Perform Apex Test Checkbox Test';
    }

    Test.startTest();
    DMLUtils.doOperate(DMLUtils.DMLOperation.DO_UPDATE, accounts); // TDD Test Fail Before Trigger
    Test.stopTest();

    // Retrieve Account
    retrievedAccount = [
      SELECT Test_Checkbox__c
      FROM Account
      WHERE Id = :accounts[0].id
      LIMIT 1
    ];

    // Assert
    Assert.areEqual(
      true,
      retrievedAccount.Test_Checkbox__c,
      'Checkbox should be true when Name is "Perform Test Checkbox Test" '
    );
  }
  @isTest
  static void negativeUpdateTest() {
    // Local Variables
    List<Account> accounts;
    Account retrievedAccount;

    // Setup test Data
    // Add Account that name is 'NOT Perform Apex Test Checkbox Test' and update to 'Perform Apex Test Checkbox Test'
    accounts = AccountTriggerFactory.createAccount(
      'NOT Perform Apex Test Checkbox Test',
      false,
      1
    );
    DMLUtils.doOperate(DMLUtils.DMLOperation.DO_INSERT, accounts);

    // Execute Update Account
    for (Account acc : accounts) {
      acc.name = 'Perform Apex Test Checkbox Test UPDATED';
    }

    Test.startTest();
    DMLUtils.doOperate(DMLUtils.DMLOperation.DO_UPDATE, accounts); // TDD Test Fail Before Trigger
    Test.stopTest();

    // Retrieve Account
    retrievedAccount = [
      SELECT Test_Checkbox__c
      FROM Account
      WHERE Id = :accounts[0].id
      LIMIT 1
    ];

    // Assert
    Assert.areEqual(
      false,
      retrievedAccount.Test_Checkbox__c,
      'Checkbox should be false when Name is updated from "NOT Perform Apex Test Checkbox Test" to "Perform Apex Test Checkbox Test UPDATED" '
    );
  }
}