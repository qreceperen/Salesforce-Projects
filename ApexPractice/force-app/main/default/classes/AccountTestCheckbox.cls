public with sharing class AccountTestCheckbox {
  public static void setCheckboxOnInsert(List<Account> accounts) {
    for (Account account : accounts) {
      if (account.name == 'Perform Apex Test Checkbox Test') {
        account.Test_Checkbox__c = true;
      }
    }
  }
  public static void setCheckboxOnUpdate(List<Account> newAccounts) {
    // Check if name is updated within old map.
    for (Account newAccount : newAccounts) {
      newAccount.Test_Checkbox__c = (newAccount.Name ==
      'Perform Apex Test Checkbox Test');
    }
  }
}
