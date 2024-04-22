Map<String,Object> accountFields = new Map<String,Object>();

accountFields.put('Name','Burlington Textiles');
accountFields.put('Phone', '123-456-7890');

Id newAccountId = AccountContactManagerController.createAccount(accountFields);

system.debug('New Account ID: ' + newAccountId);
