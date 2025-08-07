public class LeaseStatusChangeStrategy implements ITriggerStrategy {

    public void execute() {
        System.debug('🔄 LeaseStatusChangeStrategy.execute() started');

        TriggerContext context = TriggerContext.getInstance();
        Map<Id, Lease__c> newMap = (Map<Id, Lease__c>) context.newMap;
        Map<Id, Lease__c> oldMap = (Map<Id, Lease__c>) context.oldMap;

        Set<Id> unitIdsToCheck = new Set<Id>();

        // Identify leases where status changed to Expired or Draft
        for (Id leaseId : newMap.keySet()) {
            Lease__c newLease = newMap.get(leaseId);
            Lease__c oldLease = oldMap.get(leaseId);

            if (newLease.Unit__c != null &&
                newLease.Status__c != oldLease.Status__c &&
                (newLease.Status__c == 'Expired' || newLease.Status__c == 'Draft')) {

                unitIdsToCheck.add(newLease.Unit__c);
            }
        }

        System.debug('📦 Units to check for release: ' + unitIdsToCheck);

        if (unitIdsToCheck.isEmpty()) return;

        // Query active leases for those units
        List<AggregateResult> activeLeaseCounts = [
            SELECT Unit__c unitId, COUNT(Id) total
            FROM Lease__c
            WHERE Unit__c IN :unitIdsToCheck
            AND Status__c = 'Active'
            GROUP BY Unit__c
        ];

        Set<Id> unitsWithOtherActiveLeases = new Set<Id>();
        for (AggregateResult ar : activeLeaseCounts) {
            unitsWithOtherActiveLeases.add((Id) ar.get('unitId'));
        }

        // Prepare Unit__c updates for units that now have no active leases
        List<Unit__c> unitsToFree = new List<Unit__c>();
        for (Id unitId : unitIdsToCheck) {
            if (!unitsWithOtherActiveLeases.contains(unitId)) {
                unitsToFree.add(new Unit__c(Id = unitId, Status__c = 'Available'));
            }
        }

        if (!unitsToFree.isEmpty()) {
            update unitsToFree;
            System.debug('✅ Units marked Available after lease status change: ' + unitsToFree.size());
        } else {
            System.debug('ℹ️ No units needed status update');
        }
    }
}
