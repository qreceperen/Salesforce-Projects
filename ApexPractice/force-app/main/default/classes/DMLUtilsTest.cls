@IsTest
private without sharing class DMLUtilsTest {
	// Tests
	@IsTest
	static void doInsert() {
		// Local Variables
		Account verify;
		List<Account> verifyList;

		// Test
		Test.startTest();
		verify = new Account(
			Name = 'Test Account'
		);
		DMLUtils.doOperate(
			DMLUtils.DMLOperation.DO_INSERT,
			new List<SObject> { verify }
		);
		Test.stopTest();

		// Post-Test Queries
		verifyList = [
			SELECT 
					Id,
					Name 
			FROM 
					Account
		];
		if (verifyList.isEmpty()) {
			Assert.fail('There was a problem inserting the test Account');
		} else {
			verify = verifyList[0];
		}

		// Assertions
		Assert.isTrue(verify.Name == 'Test Account', 'The name of the test Account was not Test Account');
	}
	@IsTest
	static void doUpsert() {
		// Local Variables
		Account verify;
		List<Account> verifyList;

		// Test
		Test.startTest();
		DMLUtils.doOperate(
			DMLUtils.DMLOperation.DO_UPSERT, 
			new List<SObject> { new Account(Name = 'Test Account') }
		);
		Test.stopTest();

		// Post-Test Queries
		verifyList = [
			SELECT 
					Id,
					Name 
			FROM 
					Account
		];
		if (verifyList.isEmpty()) {
			Assert.fail('There was a problem upserting the test Account');
		} else {
			verify = verifyList[0];
		}

		// Assertions
		Assert.isTrue(verify.Name == 'Test Account', 'The name of the test Account was not Test Account');
	}
	@IsTest
	static void doDelete() {
		// Local Variables
		Account account;
		List<Account> verifyList;

		// Initialize and Insert
		account = new Account(Name = 'Test Account');
		insert account;

		// Test
		Test.startTest();
		DMLUtils.doOperate(
			DMLUtils.DMLOperation.DO_DELETE, 
			new List<SObject> { account }
		);
		Test.stopTest();

		// Post-Test Queries
		verifyList = [
			SELECT 
					Id 
			FROM 
					Account
		];
		
		// Assertions
		Assert.isTrue(verifyList.isEmpty(), 'There was a problem with the DML DELETE operation.');
	}
	@IsTest
	static void doUnDelete() {
		// Local Variables
		Account account;
		List<Account> verifyList;

		// Initialize and Insert
		account = new Account(Name = 'Test Account');
		insert account;

		// Test
		Test.startTest();
		DMLUtils.doOperate(
			DMLUtils.DMLOperation.DO_DELETE, 
			new List<SObject> { account }
		);
		DMLUtils.doOperate(
			DMLUtils.DMLOperation.DO_UNDELETE, 
			new List<SObject> { account }
		);
		// Post-Test Queries
		verifyList = [
			SELECT 
					Id 
			FROM 
					Account
		];
		
		// Assertions
		Assert.isFalse(verifyList.isEmpty(), 'There was a problem with the DML UNDELETE operation.');
	}
	@IsTest
	static void doUpdate() {
		// Local Variables
		Account verify;
		List<Account> accountList;

		// Initialize Local Variables <this will test passing in a collection>
		accountList = new List<Account> {
			new Account(
				Name = 'Test Account 1'
			),
			new Account(
				Name = 'Test Account 2'
			)
		};
		insert accountList;
		accountList[0].Name = 'Updated Test Account 1';

		// Test
		Test.startTest();
		DMLUtils.doOperate(DMLUtils.DMLOperation.DO_UPDATE, accountList);
		Test.stopTest();

		// Post-Test Queries
		accountList = [
			SELECT 
					Id,
					Name 
			FROM 
					Account
		];

		if (accountList.isEmpty()) {
			Assert.fail('There was a problem inserting accounts');
		} else {
			verify = accountList[0];
		}

		// Assertions
		Assert.isTrue(verify.Name == 'Updated Test Account 1', 'There was a problem with the DML UPDATE Operation');

	}
	@IsTest
	static void throwException() {
		// Local Variables
		List<Error_Log__c> verifyList;

		// Test
		Test.startTest();
		DMLUtils.doOperate(DMLUtils.DMLOperation.DO_INSERT, new List<SObject> { new Account() });
		Test.stopTest();

		// Post-Test Queries
		verifyList = [
			SELECT 
					Id,
					Related_Id__c,
					System__c
			FROM 
					Error_Log__c
		];

		//Assertions
		Assert.isTrue(verifyList.size() > 0, 'No Error Logs were generated');
		for (Error_Log__c each :verifyList) {
			Assert.isTrue(each.Related_Id__c == null);
			Assert.isTrue(each.System__c == null);
		}
	}
	@IsTest
	static void throwExceptionWithStringOptions() {
		// Local Variables
		List<Error_Log__c> verifyList;

		// Test
		Test.startTest();
		DMLUtils.relatedId = '12345';
		DMLUtils.subsystem = 'Test Subsystem';
		DMLUtils.doOperate(DMLUtils.DMLOperation.DO_INSERT, new List<SObject> { new Account() });
		Test.stopTest();

		// Post-Test Queries
		verifyList = [
			SELECT 
					Id,
					Related_Id__c,
					System__c
			FROM 
					Error_Log__c
		];

		//Assertions
		Assert.isTrue(verifyList.size() > 0, 'No Error Logs were generated');
		for (Error_Log__c each :verifyList) {
			Assert.isTrue(each.Related_Id__c == '12345');
			Assert.isTrue(each.System__c == 'Test Subsystem');
		}
	}
}