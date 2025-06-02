public with sharing class LeadScoringController {

    public class ScoreResult{
        @AuraEnabled public Decimal totalScore;
        @AuraEnabled public Decimal demographicScore;
        @AuraEnabled public Decimal behavioralScore;
        @AuraEnabled public Decimal engagementScore;
    }
    @AuraEnabled
    public static ScoreResult calculateScoreForSimulation(String industry, String companySize, Integer emailOpens, Integer websiteVisits ){
        // 1.create Mock Lead
        Lead mockLead = new Lead();
        mockLead.Industry = industry;
        mockLead.Company_Size__c = companySize;
        mockLead.Email_Opens__c = emailOpens;
        mockLead.Website_Visits__c = websiteVisits;

        // 2.Use existing Logic to calcualte Lead Score
        LeadScoringService.calculateScoresForLeads(new List<Lead>{mockLead});

        //3.Return All Scores
        ScoreResult result = new ScoreResult();
        result.totalScore = mockLead.Lead_Score__c;
        result.demographicScore = mockLead.Demographic_Score__c;
        result.behavioralScore = mockLead.Behavioral_Score__c;
        result.engagementScore = mockLead.Engagement_Score__c;
        return result;

    }
}