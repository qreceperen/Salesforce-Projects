public with sharing class ErrorLog {
  public static void logError(
    String className,
    String methodName,
    Exception e
  ) {
    // Capture and publish error details to the ApexErrorEvent__e
    ApexErrorEvent__e errorEvent;

    errorEvent = new ApexErrorEvent__e(
      Class_Name__c = className,
      Method_Name__c = methodName,
      Error_Message__c = e.getMessage(),
      Stack_Trace__c = e.getStackTraceString()
    );

    // Use Database.SaveResult to gracefully handle potential publishing failures
    Database.SaveResult saveResult;

    saveResult = EventBus.publish(errorEvent);
    if (!saveResult.isSuccess()) {
      System.debug(
        'Failed to publish error event. Error: ' +
        saveResult.getErrors()[0].getMessage()
      );
    }
  }
}
