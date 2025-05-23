public with sharing class ActivityServiceController {

    @AuraEnabled
    public static Map<String,Object> generateActivity(Id recordId, String recordType){
        SObject inputRecord;

        // Step 1: Query the record
        if(recordType == 'Lead'){
            inputRecord = [SELECT Id, Name, OwnerId FROM Lead WHERE Id = :recordId LIMIT 1];
        } else if(recordType == 'Contact'){
            inputRecord = [SELECT Id, LastName, OwnerId FROM Contact WHERE Id = :recordId LIMIT 1];
        } else{
            throw new AuraHandledException('Unsupported record type: ' + recordType);
        }

        // Step 2 Call the Factory
        ActivityCreator create = ActivityFactoryProducer.getCreator(recordType);

        // Step 3: Create Activity
        SObject activity = create.createActivity(inputRecord);
        insert activity;

        // Step 4: Return the Activity
        Map<String,Object> result = new Map<String,Object>();
        result.put('type', activity.getSObjectType().getDescribe().getName());
        result.put('subject', activity.get('Subject'));
        result.put('status', activity.get('Status'));
        result.put('date', activity.get('CreatedDate'));

        return result;
    }
}