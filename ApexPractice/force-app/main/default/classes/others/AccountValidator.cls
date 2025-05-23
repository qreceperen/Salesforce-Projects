public with sharing class AccountValidator implements RecordValidator {
    public List<String> validate(SObject record){
        List<String> errors = new List<String>();
        Account acc = (Account) record;
        if(String.isBlank(acc.AccountNumber)){
            errors.add('Account Number cannot be null');
        }

        if(acc.Rating == null){
            errors.add('Account Rating must be selected');
        }
        return errors;
    }
}