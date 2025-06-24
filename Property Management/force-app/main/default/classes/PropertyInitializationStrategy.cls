/**
 * Property Initialization Strategy - After Insert setup
 */
public class PropertyInitializationStrategy implements ITriggerStrategy {
    
    public void execute() {
        System.debug('⚡ PropertyInitializationStrategy: running after insert');
        TriggerContext context = TriggerContext.getInstance();
        List<Property__c> properties = (List<Property__c>) context.newRecords;
        
        // Auto-assign property manager if not specified
        assignDefaultPropertyManager(properties);
        
        // Create audit log (simulate)
        createAuditLogs(properties);
    }
    
    private void assignDefaultPropertyManager(List<Property__c> properties) {
        List<Property__c> propsToUpdate = new List<Property__c>();

        for (Property__c prop : properties) {
            if (prop.Property_Manager__c == null) {
                Property__c updatedProp = new Property__c(
                    Id = prop.Id,
                    Property_Manager__c = UserInfo.getUserId()
                );
                propsToUpdate.add(updatedProp);
            }
        }

        if (!propsToUpdate.isEmpty()) {
            PropertyService.updatePropertyManagers(propsToUpdate);
        }
    }

    
    private void createAuditLogs(List<Property__c> properties) {
        // Simulate audit logging
        System.debug('Created audit logs for ' + properties.size() + ' new properties');
    }
}