public class ValidatorFactoryProducer {
    public static RecordValidator getErrorMessage(String recordType){
        if(recordType == 'Opportunity'){
            return new OpportunityValidator();
        }if(recordType == 'Account'){
            return new AccountValidator();
        } else {
            throw new AuraHandledException('Unsupported record type: ' + recordType);
        }
        
    }
}