List<Contact> conList = ContactManagerController.getContactList();

for(Contact con : conList){
    system.debug('Contact Name --- '+ con.FirstName);
    system.debug('Account Name --- ' + con.Account.Name);
    system.debug('----------------------------------------');

}



