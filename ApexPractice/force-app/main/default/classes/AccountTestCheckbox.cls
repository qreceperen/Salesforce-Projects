public with sharing class AccountTestCheckbox {
  public static void updateCheckboxBasedOnName(List<Account> accounts) {
    for (Account account : accounts) {
      if (account.name == 'Perform Apex Test Checkbox Test') {
        account.Test_Checkbox__c = true;
      }
    }
  }
}
