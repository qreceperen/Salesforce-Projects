public with sharing class ContactManagerController {
  @AuraEnabled(cacheable=true)
  public static List<Contact> getContactList() {
    List<Contact> contacts;

    contacts = [
      SELECT Id, FirstName, LastName, Email, Account.Name
      FROM Contact
    ];
    return contacts;
  }
}
