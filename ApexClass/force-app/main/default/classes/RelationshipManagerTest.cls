@isTest
public with sharing class RelationshipManagerTest {
  @isTest
  static void retrieveAccount_TestAccountsWithContacts() {
    Map<Id, List<Contact>> createTenAccWithOneConEach;
    Map<Id, List<Contact>> accountsMapReturned;

    // Create 10 Account with One Contact Each
    createTenAccWithOneConEach = DataFactory.createAccounts(10, 1);

    // Execute method
    test.startTest();
    accountsMapReturned = RelationshipManager.retrieveAccounts();
    test.stopTest();

    // Assert Result we need to have 10 Account Retrieved
    // is 10 Account Returned?
    Assert.areEqual(
      10,
      accountsMapReturned.size(),
      'Unexpected number of accounts returned'
    );

    // Assert that each account has exactly one contact
    for (Id accountId : accountsMapReturned.keySet()) {
      Assert.areEqual(
        1,
        accountsMapReturned.get(accountId).size(),
        'Unexpected number of contacts for account ' + accountId
      );
    }
  }

  @isTest
  static void retrieveAccount_TestWithoutAccount() {
    // Do not add Any Data

    // Execute code
    test.startTest();
    Map<Id, List<Contact>> accountsMapReturned;
    accountsMapReturned = RelationshipManager.retrieveAccounts();
    test.stopTest();

    // Assert
    Assert.areEqual(
      0,
      accountsMapReturned.size(),
      'Unexpected number of Accounts Returned '
    );
  }
}
