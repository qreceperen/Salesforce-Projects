public class OpportunityValidator implements RecordValidator {
    public List<String> validate(SObject record){
        List<String> errors = new List<String>();
        Opportunity opp = (Opportunity) record;
        if(String.isBlank(opp.Name)){
            errors.add('Opportunity Name is required.');
        }
        if(opp.CloseDate == null) {
            errors.add('Close Date is required');
        }
        
        if(String.isBlank(opp.StageName)){
            errors.add('Stage must be selected.');
        }
        if(opp.Amount == null || opp.Amount<1000){
            errors.add('Amount Must be more that 1000');
        }
        return errors;
    }
}