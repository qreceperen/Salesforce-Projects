public with sharing class AccountContactController {
    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getAccounts() {
        List<AccountWrapper> accountWrapperList = new List<AccountWrapper>();
        List<Account> accounts = [
            SELECT Id, Name, Industry, Phone, (SELECT Id, Name, Phone, Email FROM Contacts)
            FROM Account
        ];

        for(Account acc: accounts) {
            AccountWrapper accWrap = new AccountWrapper();
            accWrap.account = acc;
            accWrap.contactCount = acc.Contacts.size();
            accountWrapperList.add(accWrap);
        }
        return accountWrapperList;
    }

    public class AccountWrapper {
        @AuraEnabled public Account account { get; set; }
        @AuraEnabled public Integer contactCount { get; set; }
    }
}
