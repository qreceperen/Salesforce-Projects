trigger UnitTrigger on Unit__c (before insert, before update) {
    System.debug('🔥 UnitTrigger - Start');

    // STEP 1: Build maps to track unit numbers per property
    Map<Id, Set<String>> propertyToNewUnitNumbers = new Map<Id, Set<String>>();
    Set<String> compositeKeysToCheck = new Set<String>();

    for (Unit__c unit : Trigger.new) {
        if (unit.Property__c == null) continue;

        String unitNum = unit.Unit_Number__c != null ? unit.Unit_Number__c.trim().toUpperCase() : null;
        if (String.isBlank(unitNum)) {
            unit.Unit_Number__c.addError('Unit Number is required.');
            continue;
        }

        // Store for duplicate checking in current transaction
        if (!propertyToNewUnitNumbers.containsKey(unit.Property__c)) {
            propertyToNewUnitNumbers.put(unit.Property__c, new Set<String>());
        }

        Set<String> unitNums = propertyToNewUnitNumbers.get(unit.Property__c);
        if (unitNums.contains(unitNum)) {
            unit.Unit_Number__c.addError('Duplicate Unit Number for this property in this transaction.');
        } else {
            unitNums.add(unitNum);
        }

        // Store for DB check: "propertyId|unitNumber"
        compositeKeysToCheck.add(unit.Property__c + '|' + unitNum);

        // Validate Rent
        if (unit.Monthly_Rent__c <= 0) {
            unit.Monthly_Rent__c.addError('Monthly Rent must be greater than 0.');
        }
    }

    System.debug('🧩 Composite keys to check in DB: ' + compositeKeysToCheck);

    // STEP 2: Query for existing duplicates in DB
    List<Unit__c> existingUnits = [
        SELECT Id, Property__c, Unit_Number__c
        FROM Unit__c
        WHERE Property__c IN :propertyToNewUnitNumbers.keySet()
        AND Unit_Number__c != null
    ];

    // STEP 3: Match against Trigger.new to detect duplicates in DB
    Set<String> dbKeys = new Set<String>();
    for (Unit__c existing : existingUnits) {
        String existingKey = existing.Property__c + '|' + existing.Unit_Number__c.trim().toUpperCase();
        dbKeys.add(existingKey);
    }

    for (Unit__c unit : Trigger.new) {
        if (unit.Property__c == null || String.isBlank(unit.Unit_Number__c)) continue;

        String key = unit.Property__c + '|' + unit.Unit_Number__c.trim().toUpperCase();

        // Exclude self (in case of before update)
        if (dbKeys.contains(key)) {
            Unit__c oldUnit = Trigger.isUpdate ? Trigger.oldMap.get(unit.Id) : null;
            Boolean isSameAsOld = oldUnit != null &&
                                  oldUnit.Property__c == unit.Property__c &&
                                  oldUnit.Unit_Number__c != null &&
                                  oldUnit.Unit_Number__c.trim().toUpperCase() == unit.Unit_Number__c.trim().toUpperCase();

            if (!isSameAsOld) {
                unit.Unit_Number__c.addError('Duplicate Unit Number already exists in the system for this property.');
            }
        }
    }

    System.debug('✅ UnitTrigger - Validation (with DB check) complete');
}
