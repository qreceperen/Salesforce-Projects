@isTest
public with sharing class RelationshipManagerTest {
  @TestSetup
  static void makeData() {
    // Create 10 Accounts with Contacts(1 contact for each Account)
    List<Account> accountList;
    List<Contact> contactList;

    accountList = new List<Account>();
    for (Integer i = 0; i < 10; i++) {
      Account singleAcc;
      singleAcc = new Account();
      singleAcc.Name = 'Test Account ' + i;
      accountList.add(singleAcc);
    }
    insert accountList;

    contactList = new List<Contact>();
    for (Account acc : accountList) {
      Contact singleCon;
      singleCon = new Contact();
      singleCon.LastName = 'Test Contact' + acc.Name;
      singleCon.AccountId = acc.id;
      contactList.add(singleCon);
    }
    insert contactList;
  }
}
