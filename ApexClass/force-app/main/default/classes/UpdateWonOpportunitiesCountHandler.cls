public with sharing class UpdateWonOpportunitiesCountHandler {
  //   If an opportunity is updated or inserted update Account Accordingly
  public static void handleInsertUpdate(List<Opportunity> oppListNew) {
    Set<Id> accountIds; // Collect AccountIds from Updated Opportunity
    accountIds = new Set<Id>();

    for (Opportunity opp : oppListNew) {
      if (opp.AccountId != null) {
        accountIds.add(opp.AccountId);
      }
    }
    updateAccount(accountIds);
  }
  //   If an opportunity Deleted update Account Accordingly
  public static void handleDelete(List<Opportunity> oppListOld) {
    Set<Id> accountIds; // Collect AccountIds from Deleted Opportunity
    accountIds = new Set<Id>();
    for (Opportunity opp : oppListOld) {
      if (opp.AccountId != null) {
        accountIds.add(opp.AccountId);
      }
    }
    updateAccount(accountIds);
  }

  private static void updateAccount(Set<Id> accountIds) {
    Map<Id, Integer> wonOppCountByAccount;
    AggregateResult[] aggResult;
    Id accId;
    Integer countRelatedOpps;
    List<Account> accountsToUpdate;

    wonOppCountByAccount = new Map<Id, Integer>();
    accountsToUpdate = new List<Account>();
    aggResult = [
      SELECT AccountId, COUNT(Id) countOpps
      FROM Opportunity
      WHERE AccountId IN :accountIds AND StageName = 'Closed Won'
      GROUP BY AccountId
    ];

    for (AggregateResult ar : aggResult) {
      accId = (Id) ar.get('AccountId');
      countRelatedOpps = (Integer) ar.get('countOpps');
      wonOppCountByAccount.put(accId, countRelatedOpps);
    }

    // Loop through Map and Prepare Account records for update

    for (Id accIds : wonOppCountByAccount.keySet()) {
      Account acc;
      acc = new Account();
      acc.id = accIds;
      acc.NumberOfWonOpportunities__c = wonOppCountByAccount.get(accIds);
      accountsToUpdate.add(acc);
    }
    if (!accountsToUpdate.isEmpty()) {
      try {
        update accountsToUpdate;
      } catch (DmlException e) {
        System.debug(
          'An error occured while updating accounts: ' + e.getMessage()
        );
        // Roll back all updates back
        throw e;
      }
    }
  }
}
