public with sharing class RelationshipManager {
  // Method to retrieve all accounts and their related contacts
  public static Map<Id, List<Contact>> retrieveAccounts() {
    List<Account> accounts;
    Map<Id, List<Contact>> accountContactMap;

    // Query all Account and Contact Data
    accounts = [
      SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts)
      FROM Account
    ];

    accountContactMap = new Map<Id, List<Contact>>();
    // Populate the map with data
    for (Account account : accounts) {
      accountContactMap.put(account.id, account.Contacts);
    }
    return accountContactMap;
  }

  //   Method to update the details of contact
  public static void updateContact(
    Id contactId,
    Map<String, Object> updatedFields
  ) {
    // Placeholder for actual implementation
  }

  //   Method to add a new contact to an account
  public static Id addContact(Id accountId, Contact newContact) {
    // Placeholder for actual implementation
    return null;
  }

  //   Method to remove a contact from an account
  public static void removeContact(Id ContactId) {
    // Placeholder for actual implementation
  }
}
