public with sharing class accountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        List<Account> accountList;

        accountList = [SELECT Id, Name, Type FROM Account];
        return accountList;
    }
}