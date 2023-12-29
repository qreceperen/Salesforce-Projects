public class ErrorLogEventTriggerHandler {
	// Public Runners
    public static void createErrorLogsAfterInsert(List<Error_Log_Event__e> newEvents) {
		// Local Variables
        List<Error_Log__c> newErrorLogs;
		List<Error_Log__c> serializedBulk;
        
		// Initialize Local Variables
        newErrorLogs = new List<Error_Log__c>();
		serializedBulk = new List<Error_Log__c>();

		// Logic
        for (Error_Log_Event__e ele :newEvents) {
            serializedBulk = (List<Error_Log__c>) JSON.deserialize(ele.Bulk_Errors_JSON__c, List<Error_Log__c>.class);
            newErrorLogs.addAll(serializedBulk);
        }

		// DML
        insert newErrorLogs;
    }
}