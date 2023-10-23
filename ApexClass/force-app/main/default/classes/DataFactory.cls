public with sharing class DataFactory {
  //   Create number of Accounts with number of Contacts
  public static Map<Id, List<Contact>> createAccounts(
    Integer numAccounts,
    Integer numContactsPerAccount
  ) {
    List<Account> accountList;
    List<Contact> allContactList;
    Map<Id, List<Contact>> accountContactsMap;

    accountList = new List<Account>();
    for (Integer i = 0; i < numAccounts; i++) {
      Account singleAcc;
      singleAcc = new Account();
      singleAcc.Name = 'Data Factory - Test Account ' + i;
      accountList.add(singleAcc);
    }
    insert accountList;

    accountContactsMap = new Map<Id, List<Contact>>();
    for (Account account : accountList) {
      List<Contact> contactsForAccount;
      contactsForAccount = new List<Contact>();
      for (Integer i = 0; i < numContactsPerAccount; i++) {
        Contact contact;
        contact = new Contact();
        contact.LastName = 'Data Factory - Test Contact ' + i;
        contact.AccountId = account.id;
        contactsForAccount.add(contact);
      }
      accountContactsMap.put(account.id, contactsForAccount);
    }

    allContactList = new List<Contact>();
    for (List<Contact> contacts : accountContactsMap.values()) {
      allContactList.addAll(contacts);
    }
    insert allContactList;
    return accountContactsMap;
  }
}
