public with sharing class OpportunityService {
    @AuraEnabled(cacheable=false)
    public static Id createOpportunity(Map<String, Object> oppData) {
        Opportunity opp;

        opp = new Opportunity();
        if(oppData.containsKey('Name')) {
            opp.Name = (String)oppData.get('Name');
        }
        if(oppData.containsKey('Amount')) {
            opp.Amount = Decimal.valueOf((String)oppData.get('Amount'));

        }
        if(oppData.containsKey('CloseDate')) {
            opp.CloseDate = Date.valueOf((String)oppData.get('CloseDate'));

        }
        if(oppData.containsKey('StageName')) {
            opp.StageName = (String)oppData.get('StageName');
        }
        if(oppData.containsKey('Description')) {
            opp.Description = (String)oppData.get('Description');
        }
        insert opp;
        return opp.Id;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getOpportunityStagePicklistValues() {
        List<String> values;
        Schema.DescribeFieldResult fieldResult;
        List<Schema.PicklistEntry> picklistEntries;

        values = new List<String>();
        fieldResult = Opportunity.StageName.getDescribe();
        picklistEntries = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry entry : picklistEntries) {
            values.add(entry.getValue());
        }
        return values;
    }
}
