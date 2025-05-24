List<Lead_Scoring_Rule__mdt> allActiveRules =  [SELECT DeveloperName, Field_API_Name__c, Field_Value__c, Score_Points__c, Category__c, Weight__c, Operator__c FROM Lead_Scoring_Rule__mdt WHERE Is_Active__c = true];
List<Lead> lead = [
    SELECT 
        Id, 
        Name, 
        Industry, 
        Website_Visits__c, 
        Status, 
        Email_Opens__c,
        Company_Size__c,
        Budget_Range__c,
        Decision_Timeline__c
    FROM Lead WHERE id =  '00Qak00000HLwA9EAL' ];
Lead_Scoring_Rule__mdt rule = [SELECT DeveloperName, Field_API_Name__c, Field_Value__c, Score_Points__c, Category__c, Weight__c, Operator__c FROM Lead_Scoring_Rule__mdt WHERE DeveloperName = 'Technology_Industry_High_Score' LIMIT 1];


LeadScoringService.calculateScoresForLeads(lead);
update lead;


