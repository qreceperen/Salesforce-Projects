trigger PropertyTrigger on Property__c(
  before insert,
  before update,
  after insert,
  after update
) {
  // Step 1: Framework logic
  TriggerContext.clearInstance(); // 🔧 Reset singleton
  new PropertyTriggerHandler().execute();

  // Step 2: TEMPORARY hardcoded cascade logic for testing AFTER UPDATE
  if (Trigger.isAfter && Trigger.isUpdate) {
    List<Id> affectedPropertyIds = new List<Id>();
    // Step 1: Identify properties where Status__c changed.
    for (Property__c newProp : Trigger.new) {
      Property__c oldProp = Trigger.oldMap.get(newProp.Id);
      if (
        newProp.Status__c != oldProp.Status__c &&
        newProp.Status__c == 'Inactive'
      ) {
        affectedPropertyIds.add(newProp.Id);
      }
    }
    // Step 2: Query Related Units and Maintenance Requests
    if (!affectedPropertyIds.isEmpty()) {
      List<Unit__c> unitsToUpdate = [
        SELECT Id, Status__c, Property__c
        FROM Unit__c
        WHERE Property__c IN :affectedPropertyIds
      ];
      List<Maintenance_Request__c> requestsToUpdate = [
        SELECT Id, Status__c, Description__c, Property__c
        FROM Maintenance_Request__c
        WHERE Property__c IN :affectedPropertyIds AND Status__c != 'Completed'
      ];
      // Step 3: Modify their value
      for (Unit__c unit : unitsToUpdate) {
        if (unit.Status__c != 'Maintenance') {
          unit.Status__c = 'Maintenance';
        }
      }
      for (Maintenance_Request__c req : requestsToUpdate) {
        req.Status__c = 'Completed';
        req.Description__c += '\n\nAuto-completed due to property inactivation.';
      }
      // Step 4: DML Updates
      if (!unitsToUpdate.isEmpty()) {
        update unitsToUpdate;
      }

      if (!requestsToUpdate.isEmpty()) {
        update requestsToUpdate;
      }
    }
  }

}
