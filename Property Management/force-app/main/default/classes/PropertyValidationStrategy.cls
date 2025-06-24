public with sharing class PropertyValidationStrategy implements ITriggerStrategy {
    public void execute() {
        TriggerContext context = TriggerContext.getInstance();
        List<Property__c> properties = (List<Property__c>) context.newRecords;
        
        validatePropertyCodes(properties);
        validateTotalUnits(properties);
        setDefaultValues(properties);
    }

    private void validatePropertyCodes(List<Property__c> properties){
        Set<String> codes = new Set<String>();
        for(Property__c prop : properties) {
            if(String.isBlank(prop.Property_Code__c)){
                prop.Property_Code__c.addError('Property Code is required for: ' + prop.Name);
                continue;
            }
            if (codes.contains(prop.Property_Code__c.toUpperCase())) {
                prop.Property_Code__c.addError('Duplicate Property Code in this batch');
            }
            codes.add(prop.Property_Code__c.toUpperCase());
        }
    }

    private void validateTotalUnits(List<Property__c> properties){
        for(Property__c prop : properties){
            if(prop.Total_Units__c <= 0 || prop.Total_Units__c == null){
                prop.Total_Units__c.addError('Total Units must be greater than 0 or cannot be empty');
            }
        }
    }

    private void setDefaultValues(List<Property__c> properties) {
        for (Property__c prop : properties) {
            if (String.isBlank(prop.Status__c)) {
                prop.Status__c = 'Active';
            }
        }
    }
}