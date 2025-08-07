public with sharing class LeaseUnitOccupancyStrategy implements ITriggerStrategy {
    public void execute() {
        System.debug('🏠 LeaseUnitOccupancyStrategy.execute() started');
        TriggerContext context = TriggerContext.getInstance();
        List<Lease__c> leases = (List<Lease__c>) context.newRecords;

        Set<Id> unitIds = new Set<Id>();

        for (Lease__c lease : leases) {
            if (lease.Unit__c != null) {
                unitIds.add(lease.Unit__c);
            }
        }

        if (unitIds.isEmpty()) {
            System.debug('⚠️ No units found in new leases. Skipping.');
            return;
        }

        List<Unit__c> unitsToUpdate = new List<Unit__c>();

        for (Unit__c unit : [
            SELECT Id, Status__c
            FROM Unit__c
            WHERE Id IN :unitIds
        ]) {
            if (unit.Status__c != 'Occupied') {
                unit.Status__c = 'Occupied';
                unitsToUpdate.add(unit);
            }
        }

        if (!unitsToUpdate.isEmpty()) {
            update unitsToUpdate;
        }
    }

}