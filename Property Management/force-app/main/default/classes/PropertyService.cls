// =============================================================================
// SERVICE LAYER CLASSES
// =============================================================================

/**
 * PropertyService - Handles complex Property business logic
 * Demonstrates Service Layer Pattern with bulkification
 */
public class PropertyService {
    
    /**
     * Updates property managers - called from trigger
     */
    public static void updatePropertyManagers(List<Property__c> properties) {
        if (!properties.isEmpty()) {
            System.debug('📤 Updating properties: ' + properties);
            try {
                update properties;
            } catch (DmlException e) {
                System.debug('❌ Error updating property managers: ' + e.getMessage());
            }
        }
    }

        /**
     * Handles property status changes - cascades to related records
     */
    public static void handleStatusChanges(List<Id> propertyIds, Map<Id, Property__c> newProperties) {
        List<Unit__c> unitsToUpdate = new List<Unit__c>();
        List<Maintenance_Request__c> maintenanceToUpdate = new List<Maintenance_Request__c>();
        
        // Query related units and maintenance requests
        Map<Id, List<Unit__c>> unitsByProperty = new Map<Id, List<Unit__c>>();
        Map<Id, List<Maintenance_Request__c>> maintenanceByProperty = new Map<Id, List<Maintenance_Request__c>>();
        
        // Bulk query related records
        for (Unit__c unit : [SELECT Id, Property__c, Status__c 
                            FROM Unit__c 
                            WHERE Property__c IN :propertyIds]) {
            if (!unitsByProperty.containsKey(unit.Property__c)) {
                unitsByProperty.put(unit.Property__c, new List<Unit__c>());
            }
            unitsByProperty.get(unit.Property__c).add(unit);
        }
        
        for (Maintenance_Request__c req : [SELECT Id, Property__c, Status__c, Description__c
                                         FROM Maintenance_Request__c 
                                         WHERE Property__c IN :propertyIds AND Status__c != 'Completed']) {
            if (!maintenanceByProperty.containsKey(req.Property__c)) {
                maintenanceByProperty.put(req.Property__c, new List<Maintenance_Request__c>());
            }
            maintenanceByProperty.get(req.Property__c).add(req);
        }
        
        // Process each property's status change
        for (Id propId : propertyIds) {
            Property__c property = newProperties.get(propId);
            
            if (property.Status__c == 'Inactive') {
                // Make all units maintenance status when property is inactive
                if (unitsByProperty.containsKey(propId)) {
                    for (Unit__c unit : unitsByProperty.get(propId)) {
                        if (unit.Status__c != 'Maintenance') {
                            unit.Status__c = 'Maintenance';
                            unitsToUpdate.add(unit);
                        }
                    }
                }
                
                // Cancel open maintenance requests
                if (maintenanceByProperty.containsKey(propId)) {
                    for (Maintenance_Request__c req : maintenanceByProperty.get(propId)) {
                        req.Status__c = 'Completed';
                        req.Description__c += '\n\nAuto-completed due to property inactivation.';
                        maintenanceToUpdate.add(req);
                    }
                }
            }
        }
        
        // Bulk DML operations
        performBulkUpdates(unitsToUpdate, maintenanceToUpdate);
    }

    /**
     * Helper method for bulk DML operations
     */
    private static void performBulkUpdates(List<Unit__c> unitsToUpdate, 
                                         List<Maintenance_Request__c> maintenanceToUpdate) {
        List<Database.SaveResult> results = new List<Database.SaveResult>();
        
        if (!unitsToUpdate.isEmpty()) {
            results.addAll(Database.update(unitsToUpdate, false));
        }
        
        if (!maintenanceToUpdate.isEmpty()) {
            results.addAll(Database.update(maintenanceToUpdate, false));
        }
        
        // Log any failures
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                for (Database.Error error : result.getErrors()) {
                    System.debug('DML Error: ' + error.getMessage());
                }
            }
        }
    }

}