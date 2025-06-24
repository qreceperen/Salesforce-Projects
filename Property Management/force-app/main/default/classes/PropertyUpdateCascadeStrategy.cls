/**
 * Property Update Cascade Strategy - After Update cascading changes
 */
public class PropertyUpdateCascadeStrategy implements ITriggerStrategy {
    
    public void execute() {
        System.debug('🚨 PropertyUpdateCascadeStrategy: execute() called');
        
        TriggerContext context = TriggerContext.getInstance();
        Map<Id, Property__c> newProperties = (Map<Id, Property__c>) context.newMap;
        Map<Id, Property__c> oldProperties = (Map<Id, Property__c>) context.oldMap;
        
        List<Id> propertiesWithStatusChange = new List<Id>();
        List<Id> propertiesWithManagerChange = new List<Id>();
        
        for (Id propId : newProperties.keySet()) {
            Property__c newProp = newProperties.get(propId);
            Property__c oldProp = oldProperties.get(propId);
            System.debug('🟡 Old Status: ' + oldProp.Status__c + ', New Status: ' + newProp.Status__c);
            
            if (newProp.Status__c != oldProp.Status__c) {
                propertiesWithStatusChange.add(propId);
            }
            
            if (newProp.Property_Manager__c != oldProp.Property_Manager__c) {
                propertiesWithManagerChange.add(propId);
            }
        }
        
        // Delegate to service layer for complex operations
        if (!propertiesWithStatusChange.isEmpty()) {
            PropertyService.handleStatusChanges(propertiesWithStatusChange, newProperties);
        }
        
        // if (!propertiesWithManagerChange.isEmpty()) {
        //     PropertyService.handleManagerChanges(propertiesWithManagerChange, newProperties, oldProperties);
        // }
    }
}