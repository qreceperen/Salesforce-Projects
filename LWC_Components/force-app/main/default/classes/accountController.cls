public with sharing class accountController {
  @AuraEnabled(cacheable=true)
  public static List<Account> getAccounts(
    Integer pageNumber,
    Integer pageSize
  ) {
    integer offset;
    List<Account> accountList;

    offset = (pageNumber - 1) * pageSize;
    accountList = [
      SELECT Id, Name, Type
      FROM Account
      LIMIT :pageSize
      OFFSET :offset
    ];
    return accountList;
  }

  @AuraEnabled(cacheable=true)
  public static Integer getTotalAccountsCount(String accountType) {
    return [SELECT COUNT() FROM Account WHERE Type = :accountType];
  }

  @AuraEnabled(cacheable=true)
  public static List<String> getAccountTypes() {
    List<String> types;
    Schema.DescribeFieldResult field;

    types = new List<String>();
    field = Account.Type.getDescribe();
    for (Schema.PicklistEntry entry : field.getPicklistValues()) {
      types.add(entry.getLabel());
    }
    return types;
  }

  @AuraEnabled(cacheable=true)
  public static List<Account> getAccountsByType(
    String accountType,
    Integer pageNumber,
    Integer pageSize
  ) {
    Integer offSet;
    List<Account> accountList;

    offSet = (pageNumber - 1) * pageSize;
    accountList = [
      SELECT Id, Name, Type
      FROM Account
      WHERE Type = :accountType
      LIMIT :pageSize
      OFFSET :offSet
    ];

    return accountList;
  }
}
