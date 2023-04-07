public class ContactController {
  public static List<Contact> getContactsByAccountId(Id accountId) {
    List<Contact> contacts = [
      SELECT Id, Name, Email, Phone
      FROM Contact
      WHERE AccountId = :accountId
    ];
    return contacts;
  }

  public static void updateContactEmail(
    List<Contact> contacts,
    String newEmail
  ) {
    for (Contact c : contacts) {
      c.Email = newEmail;
    }
    update contacts;
  }
}
