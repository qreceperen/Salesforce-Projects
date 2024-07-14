public with sharing class AccountController {
    public class AccountWrapper {

        @AuraEnabled
        public Account account { get; set; }
        
        @AuraEnabled
        public Integer opportunityCount { get; set; }

        @AuraEnabled
        public List<Opportunity> opportunities { get; set; }
    }


    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getAccountListWithOpportunities() {
        List<AccountWrapper> results = new List<AccountWrapper>();
        List<Account> accountList = [SELECT Id, Name, Industry, (SELECT Id, Name FROM Opportunities) FROM Account ];

        for(Account acc : accountList ) {
            AccountWrapper wrapper = new AccountWrapper();
            wrapper.account = acc;
            wrapper.opportunityCount = acc.Opportunities.size();
            results.add(wrapper);
        }

        return results;
    }

}