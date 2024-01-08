public with sharing class AccountTestCheckbox {
  private List<Account> accounts;

  // Constructor
  public AccountTestCheckbox(List<Account> accounts) {
    this.accounts = accounts;
  }

  // QUESTION? Should i do each method private and call them from a public method or keep as is.
  public void handleInsert() {
    for (Account account : accounts) {
      if (account.name == 'Perform Apex Test Checkbox Test') {
        account.Test_Checkbox__c = true;
      }
    }
  }
  public void handleUpdate() {
    for (Account account : accounts) {
      newAccount.Test_Checkbox__c = (newAccount.Name ==
      'Perform Apex Test Checkbox Test');
    }
  }
}
