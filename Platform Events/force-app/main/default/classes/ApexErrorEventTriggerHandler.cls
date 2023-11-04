public with sharing class ApexErrorEventTriggerHandler {
  public static void handleAfterInsert(List<ApexErrorEvent__e> events) {
    List<Error_Log__c> errorLogList;

    errorLogList = new List<Error_log__c>();
    for (ApexErrorEvent__e event : events) {
      Error_Log__c error = new Error_Log__c(
        Class_Name__c = event.Class_Name__c,
        Method_Name__c = event.Method_Name__c,
        Error_Message__c = event.Error_Message__c,
        Stack_Trace__c = event.Stack_Trace__c,
        Logged_Date__c = system.now()
      );
      errorLogList.add(error);
    }
    insert errorLogList;
  }
}
