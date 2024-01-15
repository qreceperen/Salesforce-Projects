public with sharing class OpportunityController {
  @AuraEnabled(cacheable=true)
  public static List<String> getOpportunityStages() {
    // Local Variables
    Schema.DescribeFieldResult fieldResult;
    List<Schema.PicklistEntry> ple;
    List<String> stages;

    fieldResult = Opportunity.StageName.getDescribe();
    ple = fieldResult.getPicklistValues();

    stages = new List<String>();
    for (Schema.PicklistEntry p : ple) {
      stages.add(p.getLabel());
    }
    return stages;
  }

  @AuraEnabled(cacheable=true)
  // returns all opportunities according to StageName as List of Opportunity
  public static Map<String, List<Opportunity>> getOpportunitiesByStage() {
    Map<String, List<Opportunity>> opportunitiesByStage;
    List<Opportunity> opportunityList;

    opportunityList = [SELECT Id, Name, StageName FROM Opportunity];

    opportunitiesByStage = new Map<String, List<Opportunity>>();
    for (Opportunity opportunity : opportunityList) {
      if (!opportunitiesByStage.containsKey(opportunity.StageName)) {
        opportunitiesByStage.put(
          opportunity.StageName,
          new List<Opportunity>()
        );
      }
      opportunitiesByStage.get(opportunity.StageName).add(opportunity);
    }
    return opportunitiesByStage;
  }
  @AuraEnabled
  public static void updateOpportunityStage(
    String opportunityId,
    String stageName
  ) {
    // Logic to update the opportunity's stage
    Opportunity opp = [
      SELECT Id, StageName
      FROM Opportunity
      WHERE Id = :opportunityId
    ];
    opp.StageName = stageName;
    update opp;
  }

  @AuraEnabled(cacheable=true)
  public static List<Opportunity> getOpportunities() {
    List<Opportunity> opportunityList;

    opportunityList = [SELECT Id, Name, StageName, CloseDate, ExpectedRevenue FROM Opportunity];
    return opportunityList;
  }
}
