public class UnitPropertyUpdateStrategy implements ITriggerStrategy {

    public void execute() {
        System.debug('🔁 UnitPropertyUpdateStrategy.execute() started');

        TriggerContext context = TriggerContext.getInstance();
        Set<Id> propertyIds = new Set<Id>();

        // From new records (after insert/undelete)
        if (context.newRecords != null) {
            for (Unit__c unit : (List<Unit__c>) context.newRecords) {
                if (unit.Property__c != null) {
                    propertyIds.add(unit.Property__c);
                }
            }
        }

        // From old records (after delete)
        if (context.oldRecords != null) {
            for (Unit__c unit : (List<Unit__c>) context.oldRecords) {
                if (unit.Property__c != null) {
                    propertyIds.add(unit.Property__c);
                }
            }
        }

        System.debug('🏘 Property IDs to update: ' + propertyIds);

        if (!propertyIds.isEmpty()) {
            PropertyService.recalculatePropertyMetrics(propertyIds);
        }

        System.debug('✅ UnitPropertyUpdateStrategy complete');
    }
}
