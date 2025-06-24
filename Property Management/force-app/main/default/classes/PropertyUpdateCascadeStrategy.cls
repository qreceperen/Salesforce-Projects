/**
 * Property Update Cascade Strategy - After Update cascading changes
 */
public class PropertyUpdateCascadeStrategy implements ITriggerStrategy {
    public void execute() {
        TriggerContext context = TriggerContext.getInstance();
        Map<Id, Property__c> newProperties = (Map<Id, Property__c>) context.newMap;
        Map<Id, Property__c> oldProperties = (Map<Id, Property__c>) context.oldMap;

        List<Id> propertiesWithStatusChange = new List<Id>();

        for (Id propId : newProperties.keySet()) {
            Property__c newProp = newProperties.get(propId);
            Property__c oldProp = oldProperties.get(propId);

            if (newProp.Status__c != oldProp.Status__c && newProp.Status__c == 'Inactive') {
                propertiesWithStatusChange.add(propId);
            }
        }

        if (!propertiesWithStatusChange.isEmpty()) {
            System.debug('🔁 Calling PropertyService.handleStatusChanges from Strategy');
            PropertyService.handleStatusChanges(propertiesWithStatusChange, newProperties);
        }
    }
}
