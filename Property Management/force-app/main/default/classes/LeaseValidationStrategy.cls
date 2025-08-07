public with sharing class LeaseValidationStrategy implements ITriggerStrategy {
    public void execute() {
        TriggerContext context = TriggerContext.getInstance();
        List<Lease__c> leases = (List<Lease__c>) context.newRecords;

        for (Lease__c lease : leases) {
            System.debug('🧪 Validating lease: ' + lease.Id);

            // Required Field Check
            if (lease.Property__c == null) {
                lease.Property__c.addError('Property is required');
            }

            if (lease.Unit__c == null) {
                lease.Unit__c.addError('Unit is required');
            }

            if (lease.Tenant__c == null) {
                lease.Tenant__c.addError('Tenant is required');
            }

            // Date Validation
            if (lease.Start_Date__c != null && lease.End_Date__c != null && lease.Start_Date__c >= lease.End_Date__c) {
                lease.End_Date__c.addError('End Date must be after Start Date');
            }

            // Rent Validation
            if (lease.Monthly_Rent__c <= 0) {
                lease.Monthly_Rent__c.addError('Monthly Rent must be greater that 0');
            }
        }
        System.debug('✅ LeaseValidationStrategy complete');
    }
}