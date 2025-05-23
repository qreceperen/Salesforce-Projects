public with sharing class ContactActivityCreator implements ActivityCreator {
    public SObject createActivity(SObject record){
        Contact contact = (Contact) record;
        Task task = new Task();
        task.Subject = 'Follow up with Contact: ' + contact.LastName;
        task.status = 'Not Started';
        task.Priority = 'Normal';
        task.WhoId = contact.Id;
        task.OwnerId = contact.OwnerId;   
        return task;
    }
}