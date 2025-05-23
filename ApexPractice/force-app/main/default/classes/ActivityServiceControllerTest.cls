@isTest
public with sharing class ActivityServiceControllerTest {

    @TestSetup
    static void makeData(){
        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Factory Inc.');

        insert lead;

        Contact contact = new Contact(
            LastName = 'Test');

        insert contact;

        Account account = new Account(
            Name = 'Test Account');
    }  



    @isTest
    static void creatingTaskForLeadThroughProducer(){
        Lead leadRecord = [SELECT Id, LastName, OwnerId FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        String recordType = 'Lead';

        Test.startTest();
            Map<String,Object> generatedLeadTask = ActivityServiceController.generateActivity(leadRecord.Id, recordType);
        Test.stopTest();
        
        // Assertions
        Assert.areEqual('Task', generatedLeadTask.get('type'));
        Assert.isTrue(((String) generatedLeadTask.get('subject')).contains('Lead'));
        Assert.areEqual('Not Started', generatedLeadTask.get('status'));
        // Assert.areNotEqual(null, generatedLeadTask.get('date'));
    }
    @isTest
    static void creatingTaskForContactThroughProducer(){
        Contact contactRecord = [SELECT Id, LastName, OwnerId FROM Contact WHERE LastName = 'Test' LIMIT 1];
        String recordType = 'Contact';

        Test.startTest();
            Map<String,Object> generatedContactTask = ActivityServiceController.generateActivity(contactRecord.Id, recordType);
        Test.stopTest();
        
        // Assertions
        Assert.areEqual('Task', generatedContactTask.get('type'));
        Assert.isTrue(((String) generatedContactTask.get('subject')).contains('Contact'));
        Assert.areEqual('Not Started', generatedContactTask.get('status'));
    }

    @isTest
static void throwsErrorForUnsupportedRecordType() {
    Account account = [SELECT Id, Name FROM Account LIMIT 1];
    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        // Use an unsupported record type (e.g., 'Account')
        ActivityServiceController.generateActivity('account.id', 'Account');

        // If no exception is thrown, fail the test
        Assert.fail('Expected AuraHandledException was not thrown');
    } catch (AuraHandledException e) {
        exceptionThrown = true;

        // Optional: assert on message
        Assert.isTrue(e.getMessage().contains('Unsupported record type'), 'Exception message mismatch');
    }
    Test.stopTest();

    // Ensure the catch block was hit
    Assert.isTrue(exceptionThrown, 'The exception was not thrown as expected');
}


}