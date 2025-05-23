@IsTest
private without sharing class ErrorLogTest {
	// Tests
    @IsTest
    static void testAsync() {
		// Local Variables
		Error_Log__c el;

		// Test
        Test.startTest();
        dummyFuture();
        Test.stopTest();

		// Post-Test Queries
        el = [
			SELECT 
					Method__c,
					System__c 
			FROM 
					Error_Log__c 
			LIMIT 1
		];

		// Assertions
        System.assertEquals('ErrorLogTest', el.System__c);
        System.assertEquals('dummyFuture', el.Method__c);
    }
    @IsTest
    static void testEmptyList() {
		// Local Variables
		List<Error_Log__c> errors;

		// Test
        Test.startTest();
        ErrorLog.sendEvent(new List<Error_Log__c> (), true);
        ErrorLog.sendEvent(new List<Error_Log__c> (), false);
        Test.stopTest();
        
		// Post-Test Queries
        errors = [
			SELECT 
					Id 
			FROM 
					Error_Log__c
		];

		// Assertions
        System.assert(errors.isEmpty());
    }
    @IsTest
    static void testLog() {
		// Test
        ErrorLog.log('here', 'ohya', null);
    }
    @IsTest
    static void testException() {
		// Local Variables
		Error_Log__c el;

		// Test
        try {
            throw new CustomException('Foo');
        } catch(Exception e) {
            ErrorLog.log('here', e, null);
        }
        
		// Post-Test Queries
        el = [
			SELECT 
					Class__c, 
					Method__c 
			FROM 
					Error_Log__c 
			LIMIT 
					1
		];

		// Assertions
        System.assertEquals('ErrorLogTest', el.Class__c);
        System.assertEquals('testException', el.Method__c);
    }
    @IsTest
    static void testInsert() {
		// Local Variables
		Error_Log__c el;
		
		// Test
        ErrorLog.log('Test', Database.insert(new List<Account>{new Account()}, false));

		// Post-Test Queries
        el = [
			SELECT 
					Method__c 
			FROM 
					Error_Log__c 
			LIMIT 
					1
		];

		//Assertions
        System.assertEquals('testInsert', el.Method__c);
    }
    @IsTest
    static void testUpsert() {
		// Local Variables
		Error_Log__c el;

		// Test
        ErrorLog.log('Test', Database.upsert(new List<Account>{new Account()}, false));

		// Post-Test Queries
        el = [
			SELECT 
					Method__c 
			FROM 
					Error_Log__c 
			LIMIT 
					1
		];

		// Assertions
        System.assertEquals('testUpsert', el.Method__c);
    }
    @IsTest
    static void testUpsertWithFieldVal() {
		// Local Variables
		Error_Log__c el;

		// Test
        ErrorLog.log(
			'Test', 
			Database.upsert(new List<Account> { new Account() }, false), 
			new List<Account> { new Account() },
			Account.sObjectType.getDescribe().getName(), 
			new List<String> { 'Name' }
		);

		// Post-Test Queries
        el = [
			SELECT 
					Method__c 
			FROM 
					Error_Log__c 
			LIMIT 
					1
		];

		// Assertions
        System.assertEquals('testUpsertWithFieldVal', el.Method__c);
    }
    @IsTest
    static void testDelete() {
		// Local Variables
		Account a;
		Error_Log__c el;

		// Create Test DML Operations
        a = new Account(Name='foo');
        insert a;
        delete a;

		// Test
        ErrorLog.log('Test', Database.delete(new List<Account> { a }, false));

		// Post-Test Queries
        el = [
			SELECT 
					Method__c 
			FROM 
					Error_Log__c 
			LIMIT 
					1
		];

		// Assertions
        System.assertEquals('testDelete', el.Method__c);
    }
    @IsTest
    static void stressTest() {
		// Local Variables
        List<Error_Log__c> errList;
        Integer stress_size = 200;
        String stress_string = '';

		// Initialize Local Variables
        errList = new List<Error_Log__c>();
        for (Integer i = 0; i < Math.round(ErrorLog.max_JSON_length/stress_size); i++) {
            stress_string += 'a';
        }
        for (Integer i = 0; i < stress_size; i++) {
            errList.add(ErrorLog.createLog('ErrorLogTest', stress_string, new DMLException(), null));
        }
        
		// Test
        Test.startTest();
        ErrorLog.sendEvent(errList, true);
        Test.stopTest();
        
		// Post-Test Queries
        errList = [
			SELECT 
					Method__c 
			FROM 
					Error_Log__c 
			WHERE 
					System__c = 'ErrorLogTest'
		];

		// Assertions
        System.assertEquals(stress_size, errList.size());
    }

	// Helper Logic
    @future
    static void dummyFuture() {
        ErrorLog.sendEvent(new List<Error_Log__c> { ErrorLog.createLog('ErrorLogTest', '', new DMLException(), null) }, true);
    }
}