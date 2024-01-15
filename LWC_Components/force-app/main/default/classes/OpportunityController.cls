public with sharing class OpportunityController {
  @AuraEnabled(cacheable=true)
  public static List<Opportunity> getOpportunities(Integer pageNumber, Integer pageSize) {
      Integer offset = (pageNumber - 1) * pageSize;
      return [SELECT Id, Name, StageName, CloseDate, ExpectedRevenue 
              FROM Opportunity 
              ORDER BY Name 
              LIMIT :pageSize OFFSET :offset];
  }

  @AuraEnabled(cacheable=true)
  public static Integer getTotalOpportunitiesCount() {
      return [SELECT count() FROM Opportunity];
  }
}
