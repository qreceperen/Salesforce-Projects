@isTest
public with sharing class DataFactoryTest {
  @isTest
  static void createAccounts_createTenAccOneConEach() {
    //No data First
    test.startTest();
    Map<Id, List<Contact>> returnedAccountsContacts;
    returnedAccountsContacts = DataFactory.createAccounts(10, 1);
    test.stopTest();

    // Assert
    // Assert number of account returned
    Assert.areEqual(
      10,
      returnedAccountsContacts.size(),
      'Unexpected Number of Account is returned'
    );

    // Assert if Contact is relate to correct Account
    for (Id accountId : returnedAccountsContacts.keySet()) {
      List<Contact> contactList;
      contactList = returnedAccountsContacts.get(accountId);

      for (Contact con : contactList) {
        Assert.areEqual(
          accountId,
          con.AccountId,
          'Contact is not related to the correct Account'
        );
      }
    }

    // Assert Number of Contact created for each account. Should be one.
    for (List<Contact> contactList : returnedAccountsContacts.values()) {
      Assert.areEqual(
        1,
        contactList.size(),
        'Unexpected number of contact returned'
      );
    }
  }

  @isTest
  static void createAccounts_createZeroAccTwoConEach() {
    Map<Id, List<Contact>> returnedAccAndCon;
    List<Contact> conList;
    // No Data First

    // Execute
    test.startTest();
    returnedAccAndCon = DataFactory.createAccounts(0, 2);
    test.stopTest();

    // Assert
    // Assert no Account created
    Assert.areEqual(
      0,
      returnedAccAndCon.size(),
      'Unexpected number of Accounts returned'
    );

    // Confirm not Contact is Created
    conList = [SELECT Id FROM Contact];
    Assert.areEqual(
      0,
      conList.size(),
      'Unexpected number of Contacts returned'
    );
  }

  @isTest
  static void createAccounts_createTenAccZeroConEach() {
    Map<id, List<Contact>> returnedAccConMap;
    List<Contact> contactList;
    // No Data first

    // Execute
    test.startTest();
    returnedAccConMap = DataFactory.createAccounts(10, 0);
    test.stopTest();

    // Assert
    // Confirm Ten Account is created
    Assert.areEqual(
      10,
      returnedAccConMap.size(),
      'Unexpected number of Accounts returned'
    );

    // Confirm no Contact Created
    contactList = [SELECT Id FROM Contact];
    Assert.areEqual(
      0,
      contactList.size(),
      'Unexpected number of Contact returned '
    );
  }
}
