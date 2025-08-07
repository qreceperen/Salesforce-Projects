public class UnitService {

    /**
     * Called when Unit__c.Status__c changes
     * @param changedUnitIds List of Unit__c IDs whose status changed
     * @param newUnits Map of Unit__c records from Trigger.newMap
     */
    public static void handleStatusChanges(List<Id> changedUnitIds, Map<Id, Unit__c> newUnits) {
        System.debug('🔧 UnitService.handleStatusChanges()');
        System.debug('🔍 Units with status changes: ' + changedUnitIds);

        for (Id unitId : changedUnitIds) {
            Unit__c unit = newUnits.get(unitId);
            System.debug('➡️ Unit: ' + unitId + ' new status: ' + unit.Status__c);

            // Future logic could go here:
            // - Notify property manager
            // - Create a maintenance request if moved to "Maintenance"
            // - Log audit record
        }

        // Optional: DML, notifications, etc. can be added later
    }
}
