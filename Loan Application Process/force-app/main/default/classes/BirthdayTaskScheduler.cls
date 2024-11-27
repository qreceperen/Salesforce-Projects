global class BirthdayTaskScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        List<Contact> contacts = [SELECT Id, Name, OwnerId, Next_Birthday__c FROM Contact WHERE Next_Birthday__c = :Date.today()];

        List<Task> tasks = new List<Task>();
        // create Task for each contact
        for(Contact contact : contacts){
            Task task = new Task();
            task.Subject = 'Birthday reminder for  '+ contact.Name;
            task.WhoId = contact.id;
            task.OwnerId = contact.OwnerId;
            task.ActivityDate = Date.today();
            task.Status = 'Not Started';
            tasks.add(task);
        }
        if(!tasks.isEmpty()){
            try{
                insert tasks;
            }catch(Exception e){
                system.debug('Error Message ' + e.getMessage());
            }
        }
        System.debug('Scheduled Apex created ' + tasks.size() + ' birthday reminder tasks.');
    }
}