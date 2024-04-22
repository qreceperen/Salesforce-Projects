public with sharing class LoanController {
  @AuraEnabled(cacheable=true)
  public static List<Loan__c> getLoans(Id accountId) {
    return [
      SELECT
        Id,
        Loan_Type__c,
        Loan_Amount__c,
        Interest_Rate__c,
        Loan_Term__c,
        Application_Status__c,
        Application_Date__c
      FROM Loan__c
      WHERE Related_Account__c = :accountId
    ];
  }

  @AuraEnabled(cacheable=true)
  public static Loan__c getLoanById(Id loanId) {
    return [
      SELECT
        Id,
        Name,
        Loan_Type__c,
        Loan_Amount__c,
        Interest_Rate__c,
        Loan_Term__c,
        Application_Status__c,
        Application_Date__c
      FROM Loan__c
      WHERE Id = :loanId
      LIMIT 1
    ];
  }
}
