public with sharing class accountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer pageNumber, Integer pageSize) {
        integer offset;
        List<Account> accountList;

        offset = (pageNumber-1) * pageSize;
        accountList = [SELECT Id, Name, Type FROM Account LIMIT :pageSize OFFSET :offset];
        return accountList;
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalAccountsCount() {
        return [SELECT count() FROM Account];
    }
}