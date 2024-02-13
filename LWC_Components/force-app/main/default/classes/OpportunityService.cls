public with sharing class OpportunityService {
    @AuraEnabled(cacheable=false)
    public static Id createOpportunity(
        String name,
        Decimal amount,
        Date closeDate,
        String stage
    ) {
        Opportunity opportunity = new Opportunity(
            Name = name,
            Amount = amount,
            CloseDate = closeDate,
            StageName = stage
        );
        insert opportunity;
        return opportunity.id;
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
