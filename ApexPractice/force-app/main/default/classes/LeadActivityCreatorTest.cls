@isTest
public with sharing class LeadActivityCreatorTest {
    @TestSetup
    static void makeData(){
        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Factory Inc.',
            OwnerId = UserInfo.getUserId()
        );
        insert lead;
    } 
    
    @isTest
    static void createTaskForLead(){
        // Step 1: Get Lead Record
        Lead lead = [SELECT Id, Name, OwnerId FROM Lead WHERE Name = 'Test Lead' LIMIT 1];

        //Step 2: Use the factory to get right Activity creator
        ActivityCreator creator = ActivityFactoryProducer.getCreator('Lead');

        // Step 3: Create the activity
        SObject activity = creator.createActivity(lead);

        // Step 4: Check if task is created
        Task task = (Task) activity;
        Assert.areEqual('Not Started', task.Status);
        Assert.isTrue(task.Subject.contains(lead.Name));
        Assert.areEqual(lead.Id, task.WhoId);

    }
}