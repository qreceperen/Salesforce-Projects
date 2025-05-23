public with sharing class ActivityFactoryProducer {
    public static ActivityCreator getCreator(String recordType){
        if(recordType == 'Lead'){
            return new LeadActivityCreator();
        } else if(recordType == 'Contact'){
            return new ContactActivityCreator();
        } else {
            throw new AuraHandledException('Unsupported record type: ' + recordType);
        }
    }
}