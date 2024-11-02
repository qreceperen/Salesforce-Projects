List<Account> accountRecords = [SELECT Id FROM Account];

List<Id> accountIds = new List<Id>();
for(Account acc : accountRecords) {
    accountIds.add(acc.Id);
}

AccountContactMapping acm = new AccountContactMapping(accountIds);

acm.mapPhoneField();
