public with sharing class mapPractice {
  public static void getAccount(Set<Id> accountId) {
    map<Id, Account> accMap = new Map<id, Account>(
      [SELECT Id, Name FROM Account WHERE Id IN :accountId]
    );

    for (Id accId : accountId) {
      Account acc = accMap.get(accId);
      System.debug('Account Name: ' + acc.Name);
    }
  }
}
