public without sharing class ErrorLog {
	// Properties
    @TestVisible
    static final Integer max_JSON_length = Error_Log_Event__e.Bulk_Errors_JSON__c.getDescribe().getLength();
    
	// Public Runners
	//----Use this to instantiate an Error Log and return it
    public static Error_Log__c createLog(String sSystem, String sError, Exception oException, String relatedId) {
		// Local Variables
        Error_Log__c oErrorLog;
		String s;
		String sClass;

		// Initialize Local Variables
        oErrorLog = new Error_Log__c();
        s = oException.getStackTraceString();
		sClass = '';
        
		// Logic
        //----Remove all ErrorLog entries in stack trace
        while (s.substringBefore('\n').startsWithIgnoreCase('Class.ErrorLog.')) {
        	s = s.substringAfter('\n');
        }
        oErrorLog.Stack_Trace__c = s;
        if (s.startsWithIgnoreCase('Class.')) {
            sClass = s.substringAfter('Class.');
            if (sClass.indexOf('.') >= 0) {
                oErrorLog.Class__c = s.substringAfter('Class.').substringBefore('.');
                oErrorLog.Method__c = s.substringBefore(':').substringAfterLast('.');
            } else {
                oErrorLog.Class__c = s.substringAfter('Class.').substringBefore(':');
            }
        } else {
            oErrorLog.Method__c = s.substringBefore(':');
        }
        try { 
			oErrorLog.Line_Number__c = Integer.valueOf(s.substringAfter(': line ').substringBefore(',')); 
		} catch (Exception e) { 
			oErrorLog.Line_Number__c = -1; 
		}
        oErrorLog.Related_Id__c = relatedId;
        oErrorLog.Error_Message__c = sError;
        oErrorLog.System__c = sSystem;
       
	   	// Return
        return oErrorLog;
    }
	//----Use this to insert an Error Log without an Exception
    public static void log(String sSystem, String sError, String relatedId) {
        log(sSystem, sError, new DMLException(), relatedId);
    }
	//----Use this to insert an Error Log with an Exception
    public static void log(String sSystem, Exception e, String relatedId) {
        log(sSystem, e.getMessage(), e, relatedId);
    }
	//----Use this to insert an Error Log given a Database.SaveResult[]
	public static void log(String sSystem, Database.SaveResult[] srList) { 
		// Local Variables
        List<Error_Log__c> lstErrors;
		String sError;

		// Initialize Local Variables
        lstErrors = new List<Error_Log__c>();
		sError = '';
        
		// Logic
        for (Database.SaveResult sr : srList) {
            if (! sr.isSuccess()) {
                //----Operation failed, so get all errors
                for (Database.Error err :sr.getErrors()) {
                    if (String.isNotBlank(sError)) {
						sError += '\n';
					}
                    sError += err.getStatusCode() + ': ' + err.getMessage();
                }
                lstErrors.add(createLog(sSystem, sError, new DMLException(), sr.getId()));
            }
        }
        if (! lstErrors.isEmpty()) {
            sendEvent(lstErrors, false);
        }
    }
	//----Use this to insert an Error Log given a Database.UpsertResult[]
    public static void log(String sSystem, Database.UpsertResult[] srList) { 
		// Local Variables
        List<Error_Log__c> lstErrors;
		String sError;

		// Initialize Local Variables
        lstErrors = new List<Error_Log__c>();
		sError = '';
        
		// Logic
        for (Database.UpsertResult sr : srList) {
            if (! sr.isSuccess()) {
                //---- Operation failed, so get all errors
                for(Database.Error err :sr.getErrors()) {
                    if (String.isNotBlank(sError)) {
						sError += '\n';
					}
                    sError += err.getStatusCode() + ': ' + err.getMessage();
                }
                lstErrors.add(createLog(sSystem, sError, new DMLException(), sr.getId()));
            }
        }
        if (! lstErrors.isEmpty()) {
            sendEvent(lstErrors, false);
        }
    }
	//----Use this to insert an Error Log with field values given a Database.UpsertResult[]
    public static void log(String sSystem, Database.UpsertResult[] srList, List<sObject> upsertRecList, String objectAPIName, List<String> fieldsAPINames ) { 
		// Local Variables
        List<Error_Log__c> lstErrors;
		Map<String, Schema.SObjectField> fieldMap;
		String fieldValues;
        Integer recIndex;
		String sError;
		SObject upsertRec;

		// Initialize Local Variables
        lstErrors = new List<Error_Log__c>();
		fieldMap = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap();
		fieldValues = '';
        recIndex = 0;
		sError = '';
		upsertRec = upsertRecList[recIndex];
        
		// Logic
        for (Database.UpsertResult sr :srList) {
            if (! sr.isSuccess()) {
                for (String fieldName :fieldsAPINames) {
                    fieldValues += fieldMap.get(fieldName).getDescribe().getLabel() + ':' + upsertRec.get(fieldName) + '\n';
                }
                //----Operation failed, so get all errors
                for (Database.Error err :sr.getErrors()) {
                    if (String.isNotBlank(sError)) {
						sError += '\n';
					}
                    sError += err.getStatusCode() + ': ' + err.getMessage();
                }
                Error_Log__c errLog = createLog(sSystem, sError, new DMLException(), sr.getId());
                errLog.Field_Values__c = fieldValues;
                lstErrors.add(errLog);
            }
            recIndex++;
        }
        if (! lstErrors.isEmpty()) {
            sendEvent(lstErrors, false);
        }
    }
	//----Use this to insert an Error Log given a Database.DeleteResult[]
    public static void log(String sSystem, Database.DeleteResult[] srList) { 
		// Local Variables
        List<Error_Log__c> lstErrors;
		String sError;
        
		// Initialize Local Variables
        lstErrors = new List<Error_Log__c>();
		sError = '';

		// Logic
        for (Database.DeleteResult sr :srList) {
            if (! sr.isSuccess()) {
                //----Operation failed, so get all errors
                for (Database.Error err :sr.getErrors()) {
                    if (String.isNotBlank(sError)) {
						sError += '\n';
					}
                    sError += err.getStatusCode() + ': ' + err.getMessage();
                }
                lstErrors.add(createLog(sSystem, sError, new DMLException(), sr.getId()));
            }
        }
        if (! lstErrors.isEmpty()) {
            sendEvent(lstErrors, false);
        }
    }

	// Logic
	//----Use this to publish an event given an Exception
    static void log(String sSystem, String sError, Exception oException, String relatedId) {
        sendEvent(new List<Error_Log__c> { createLog(sSystem, sError, oException, relatedId) }, false);
    }
    
	// Helper Logic
	//----Use this to serialize errors and publish them as events
    @TestVisible
    static void sendEvent(List<Error_Log__c> lstErrors, Boolean test_bypass) {
		// Test Mode Guard Clause
        if (Test.isRunningTest() && ! test_bypass) {
            insert lstErrors;
            return;
        }

		// Local Variables
        List<Error_Log__c> currEventErrors;
        List<Error_Log__c> errors;
        List<Error_Log_Event__e> eventList;
		String js;
        Error_Log__c prev_error;

		// Initialize Local Variables
        currEventErrors = new List<Error_Log__c>();
        errors = lstErrors.clone();
        eventList = new List<Error_Log_Event__e>();
		js = '';
        prev_error = new Error_Log__c();

		// Logic
        while (! errors.isEmpty()) {
            prev_error = errors.remove(errors.size()-1);
            currEventErrors.add(prev_error);
            js = JSON.serialize(currEventErrors);
            if (js.length() > max_JSON_length - 1) {
                prev_error = currEventErrors.remove(currEventErrors.size()-1);
                eventList.add(new Error_Log_Event__e(Bulk_Errors_JSON__c = JSON.serialize(currEventErrors)));
                currEventErrors = new List<Error_Log__c>();
                errors.add(prev_error);
            } else if (errors.isEmpty()) {
                eventList.add(new Error_Log_Event__e(Bulk_Errors_JSON__c = js));
            }
        }
        if (! eventList.isEmpty()) {
            EventBus.publish(eventList);
        }
    }
}