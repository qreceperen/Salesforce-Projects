@isTest
public with sharing class ContactActivityCreatorTest {
    @TestSetup
    static void makeData(){
        Contact contact = new Contact(LastName = 'Test');
        insert contact;
    }

    @isTest
    static void createActivityForContact(){
        // Step 1: Retrieve Contact
        Contact contact = [SELECT Id, LastName, OwnerId FROM Contact WHERE LastName = 'Test' LIMIT 1];

        // Step 2: Use the factort to get right Activity creator
        ActivityCreator creator = ActivityFactoryProducer.getCreator('Contact');

        //Step 3: Create the activity
        SObject activity = creator.createActivity(contact);

        // Step 4: Check if task created in memory
        Task task = (Task) activity;
        Assert.areEqual('Not Started', task.Status);
        Assert.isTrue(task.Subject.contains(contact.LastName));
        Assert.areEqual(contact.Id, task.WhoId);
    }
}