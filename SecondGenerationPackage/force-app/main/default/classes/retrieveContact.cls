public with sharing class retrieveContact {
  public static List<Contact> getContact() {
    List<Contact> contacts;
    contacts = [SELECT Id FROM Contact];
    return contacts;
  }

  public static void allAccounts() {
    Account acc = [SELECT Id FROM Account LIMIT 1];
  }
}
