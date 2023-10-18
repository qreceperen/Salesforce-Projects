@RestResource(urlMapping='/ContactSync/*')
global with sharing class ContactSyncAPI {
  @HttpPost
  global static String createOrUpdateContact(
    String externalId,
    String firstName,
    String lastName,
    String email
  ) {
    Contact contact;
    List<Contact> existingContacts;

    // Try to find existing contact based on the external ID
    existingContacts = [
      SELECT Id
      FROM Contact
      WHERE External_ID__c = :externalId
    ];

    // If a contact exist, update it. Otherwise, create a new contact.
    if (!existingContacts.isEmpty()) {
      contact = existingContacts[0];
      contact.FirstName = firstName;
      contact.LastName = lastName;
      contact.Email = email;
      update contact;
    } else {
      contact = new Contact();
      contact.External_ID__c = externalId;
      contact.FirstName = firstName;
      contact.LastName = lastName;
      contact.Email = email;
      insert contact;
    }
    return String.valueOf(contact.id);
  }

  @HttpGet
  global static List<Contact> getContacts() {
    List<Contact> contactList;
    contactList = [
      SELECT Id, FirstName, LastName, Email, External_ID__c
      FROM Contact
      LIMIT 10
    ];
    return contactList;
  }
}
