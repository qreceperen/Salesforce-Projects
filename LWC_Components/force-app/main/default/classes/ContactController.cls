public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        return [SELECT Id, Name, Email, Phone FROM Contact LIMIT 10];
    }
}