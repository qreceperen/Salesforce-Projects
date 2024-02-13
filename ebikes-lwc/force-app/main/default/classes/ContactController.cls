public with sharing class ContactController {
   @AuraEnabled(cacheable = true)
   public static List<Contact> getContacts(String filter) {
    String soqlQuery = 'SELECT Id, LastName, Email, Phone FROM Contact';
    if(String.isNotBlank(filter)) {
        soqlQuery += ' WHERE LastName LIKE \'%' + String.escapeSingleQuotes(filter) + '%\'';
    }
    return Database.query(soqlQuery);
   }
}