public with sharing class LeadActivityCreator implements ActivityCreator {
    public SObject createActivity(SObject record){
        Lead lead = (Lead) record;
        Task task = new Task();
        task.Subject = 'Follow up with Lead: ' + lead.Name;
        task.status = 'Not Started';
        task.Priority = 'Normal';
        task.WhoId = lead.Id;
        task.OwnerId = lead.OwnerId;   
        return task;
    }
}