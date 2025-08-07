public class UnitValidationStrategy implements ITriggerStrategy {

    public void execute() {
        System.debug('🧠 UnitValidationStrategy.execute() called');

        TriggerContext context = TriggerContext.getInstance();
        List<Unit__c> units = (List<Unit__c>) context.newRecords;
        Map<Id, Unit__c> oldMap = (Map<Id, Unit__c>) context.oldMap;

        // === Step 1: Prepare data structures ===
        Map<Id, Set<String>> propertyToNewUnitNumbers = new Map<Id, Set<String>>();
        Set<String> compositeKeysToCheck = new Set<String>();

        for (Unit__c unit : units) {
            if (unit.Property__c == null) continue;

            String unitNum = unit.Unit_Number__c != null ? unit.Unit_Number__c.trim().toUpperCase() : null;
            if (String.isBlank(unitNum)) {
                unit.Unit_Number__c.addError('Unit Number is required.');
                continue;
            }

            if (!propertyToNewUnitNumbers.containsKey(unit.Property__c)) {
                propertyToNewUnitNumbers.put(unit.Property__c, new Set<String>());
            }

            Set<String> unitNums = propertyToNewUnitNumbers.get(unit.Property__c);
            if (unitNums.contains(unitNum)) {
                unit.Unit_Number__c.addError('Duplicate Unit Number for this property in this transaction.');
            } else {
                unitNums.add(unitNum);
            }

            compositeKeysToCheck.add(unit.Property__c + '|' + unitNum);

            if (unit.Monthly_Rent__c <= 0 || unit.Monthly_Rent__c == null) {
                unit.Monthly_Rent__c.addError('Monthly Rent must be greater than 0.');
            }
        }

        System.debug('🧩 Composite keys to check in DB: ' + compositeKeysToCheck);

        // === Step 2: Query DB for duplicates ===
        List<Unit__c> existingUnits = [
            SELECT Id, Property__c, Unit_Number__c
            FROM Unit__c
            WHERE Property__c IN :propertyToNewUnitNumbers.keySet()
            AND Unit_Number__c != null
        ];

        Set<String> dbKeys = new Set<String>();
        for (Unit__c existing : existingUnits) {
            String key = existing.Property__c + '|' + existing.Unit_Number__c.trim().toUpperCase();
            dbKeys.add(key);
        }

        for (Unit__c unit : units) {
            if (unit.Property__c == null || String.isBlank(unit.Unit_Number__c)) continue;

            String key = unit.Property__c + '|' + unit.Unit_Number__c.trim().toUpperCase();

            if (dbKeys.contains(key)) {
                Unit__c oldUnit = context.isUpdate ? (oldMap != null ? oldMap.get(unit.Id) : null) : null;
                Boolean isSameAsOld = oldUnit != null &&
                                      oldUnit.Property__c == unit.Property__c &&
                                      oldUnit.Unit_Number__c != null &&
                                      oldUnit.Unit_Number__c.trim().toUpperCase() == unit.Unit_Number__c.trim().toUpperCase();

                if (!isSameAsOld) {
                    unit.Unit_Number__c.addError('Duplicate Unit Number already exists in the system for this property.');
                }
            }
        }

        System.debug('✅ UnitValidationStrategy - Validation complete');
    }
}
