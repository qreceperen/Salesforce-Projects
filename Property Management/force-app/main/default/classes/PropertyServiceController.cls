public with sharing class PropertyServiceController {
  @AuraEnabled(cacheable=true)
  public static List<Property__c> getAllProperties() {
    return [
      SELECT Id, Name, Property_Code__c, Status__c, Total_Units__c, Address__c
      FROM Property__c
      ORDER BY CreatedDate DESC
      LIMIT 100
    ];
  }
}
