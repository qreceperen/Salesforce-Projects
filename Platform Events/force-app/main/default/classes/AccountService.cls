public with sharing class AccountService {
  public static void createAccountWithoutName() {
    Account acc = new Account();

    try {
      insert acc;
    } catch (Exception e) {
      // Use the centralized ErrorLog class to handle the error
      ErrorLog.logError('AccountService', 'createAccountWithoutName', e);
    }
  }
}
