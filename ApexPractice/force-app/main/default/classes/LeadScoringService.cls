public with sharing class LeadScoringService {


    public static void calculateScoresForLeads(List<Lead> leads){
        // Step 1: Get all active scoring rules once (efficient - not in loops)
        Map<String, Lead_Scoring_Rule__mdt> activeRulesMap = getActiveLeadScoringRules();
        
        // Step 2: Process each lead individually
        for(Lead lead : leads){
            
            // Step 3: Initialize category scores for this lead
            Decimal demographicScore = 0;
            Decimal behavioralScore = 0;
            Decimal engagementScore = 0;
            
            // Step 4: Test this lead against ALL scoring rules
            for(Lead_Scoring_Rule__mdt rule : activeRulesMap.values()){
                
                // Step 5: Check if this rule applies to this lead
                Boolean ruleMatches = evaluateRule(lead, rule);
                
                // Step 6: If rule matches, add weighted points to appropriate category
                if(ruleMatches) {
                    
                    if(rule.Category__c == 'Demographic') {
                        demographicScore += (rule.Score_Points__c * rule.Weight__c);
                        
                    } else if(rule.Category__c == 'Behavioral') {
                        behavioralScore += (rule.Score_Points__c * rule.Weight__c);
                        
                    } else if(rule.Category__c == 'Engagement') {
                        engagementScore += (rule.Score_Points__c * rule.Weight__c);
                    }
                }
            }
            
            // Step 7: Update this lead with all calculated scores
            lead.Demographic_Score__c = demographicScore;
            lead.Behavioral_Score__c = behavioralScore;
            lead.Engagement_Score__c = engagementScore;
            lead.Lead_Score__c = demographicScore + behavioralScore + engagementScore;
        }
        
        // Note: Leads are updated by reference - no need to return anything
        // The calling trigger will handle the actual DML update
    }

    private static Boolean evaluateRule(Lead lead, Lead_Scoring_Rule__mdt rule) {
        String fieldName = rule.Field_API_Name__c; // like Industry
        Object leadValue = lead.get(fieldName); // like Technology (What indutry field holds )
        
        // Handle null values
        if(leadValue == null) {
            return false;
        }
        
        String operator = rule.Operator__c;
        String ruleValue = rule.Field_Value__c;
        
        try {
            // Handle different operators
            if(operator == 'Equals') {
                return String.valueOf(leadValue) == ruleValue;
                
            } else if(operator == 'Not Equals') {
                return String.valueOf(leadValue) != ruleValue;
                
            } else if(operator == 'Contains') {
                return String.valueOf(leadValue).contains(ruleValue);
                
            } else if(operator == 'Greater Than') {
                Decimal leadNumber = Decimal.valueOf(String.valueOf(leadValue));
                Decimal ruleNumber = Decimal.valueOf(ruleValue);
                return leadNumber > ruleNumber;
                
            } else if(operator == 'Less Than') {
                Decimal leadNumber = Decimal.valueOf(String.valueOf(leadValue));
                Decimal ruleNumber = Decimal.valueOf(ruleValue);
                return leadNumber < ruleNumber;
            }
            
        } catch(Exception e) {
            // Handle conversion errors (e.g., trying to convert text to number)
            System.debug('Error evaluating rule: ' + rule.DeveloperName + ', Error: ' + e.getMessage());
            return false;
        }
        
        // Default case - unknown operator
        return false;
    }

    private static Map<String, Lead_Scoring_Rule__mdt> getActiveLeadScoringRules(){
        List<Lead_Scoring_Rule__mdt> allActiveRules = [
            SELECT DeveloperName, Field_API_Name__c, Field_Value__c, Score_Points__c, Category__c, Weight__c, Operator__c
            FROM Lead_Scoring_Rule__mdt
            WHERE Is_Active__c = true
        ];

        Map<String, Lead_Scoring_Rule__mdt> activeRulesMap = new Map<String, Lead_Scoring_Rule__mdt>();
        for(Lead_Scoring_Rule__mdt rule : allActiveRules){
            activeRulesMap.put(rule.DeveloperName, rule);  
        }
        return activeRulesMap;
    }

}