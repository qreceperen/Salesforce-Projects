@isTest
private class ContactController_Test {
  @testSetup
  static void setupTestData() {
    List<Contact> multipleContacts;
    // create 15 multiple contacts
    multipleContacts = new List<Contact>();

    for (Integer i = 0; i < 15; i++) {
      Contact con;
      con = new Contact();
      con.FirstName = 'Test' + i;
      con.LastName = 'Contact' + i;
      con.Email = 'test' + i + '@example.com';
      con.Phone = '123-456-7890';
      con.Title = 'Test Title';
      multipleContacts.add(con);
    }
    insert multipleContacts;
  }
  @isTest
  static void getContactListMoreThan10Test() {
    // execute
    List<Contact> returnedContacts;
    Test.startTest();
    returnedContacts = ContactController.getContactList();
    Test.stopTest();
    // assert - We have 15 contact in database (Test Setup) we expect 10 of them
    Assert.areEqual(
      10,
      returnedContacts.size(),
      'Expected 10 contacts to be returned even if there are more in the org'
    );
  }
  @isTest
  static void getContactListLessThan10Test() {
    // We delete contacts from database total we have 15 in testSetup
    List<Contact> deleteContacts;
    deleteContacts = [SELECT id FROM Contact LIMIT 8];
    delete deleteContacts;

    List<Contact> returnedContacts;
    // execute
    Test.startTest();
    returnedContacts = ContactController.getContactList();
    Test.stopTest();

    //Assert
    Assert.areEqual(
      7,
      returnedContacts.size(),
      'Expected 7 contacts to be returned'
    );
  }
}
