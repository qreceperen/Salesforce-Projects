public class UnitStatusChangeStrategy implements ITriggerStrategy {

    public void execute() {
        System.debug('🔄 UnitStatusChangeStrategy.execute() started');

        TriggerContext context = TriggerContext.getInstance();
        Map<Id, Unit__c> newMap = (Map<Id, Unit__c>) context.newMap;
        Map<Id, Unit__c> oldMap = (Map<Id, Unit__c>) context.oldMap;

        List<Id> changedUnits = new List<Id>();

        for (Id unitId : newMap.keySet()) {
            Unit__c newUnit = newMap.get(unitId);
            Unit__c oldUnit = oldMap != null ? oldMap.get(unitId) : null;

            if (oldUnit != null && newUnit.Status__c != oldUnit.Status__c) {
                System.debug('📍 Status changed: ' + unitId + ' from ' + oldUnit.Status__c + ' to ' + newUnit.Status__c);
                changedUnits.add(unitId);
            }
        }

        if (!changedUnits.isEmpty()) {
            UnitService.handleStatusChanges(changedUnits, newMap);
        }

        System.debug('✅ UnitStatusChangeStrategy complete');
    }
}
