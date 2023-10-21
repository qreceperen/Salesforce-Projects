Map<Id, List<Contact>> returnedValue;

returnedValue = RelationshipManager.retrieveAccounts();

// system.debug(returnedValue);

List<Contact> conList;
conList = returnedValue.values();
system.debug(conList);

// for (Id accountId : returnedValue.keySet()) {
//   System.debug('Account ID: ' + accountId);
//   List<Contact> contacts = returnedValue.get(accountId);

//   for (Contact contact : contacts) {
//   }
//   System.debug(
//     'Contact ID: ' +
//     contact.Id +
//     ', First Name: ' +
//     contact.FirstName +
//     ', Last Name: ' +
//     contact.LastName
//   );
// }

