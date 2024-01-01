@isTest
public with sharing class AccountTriggerFactory {
  public static List<Account> createAccount(
    String accName,
    Boolean testCheckbox,
    Integer numberOfAccount
  ) {
    // Local Variables
    List<Account> accountList;

    // create Account(s)
    accountList = new List<Account>();
    for (Integer i = 0; i < numberOfAccount; i++) {
      Account acc = new Account(
        name = accName,
        Test_Checkbox__c = testCheckbox
      );
      accountList.add(acc);
    }
    return accountList;
  }
}
