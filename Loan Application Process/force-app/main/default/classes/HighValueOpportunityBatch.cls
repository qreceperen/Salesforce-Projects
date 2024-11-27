public with sharing class HighValueOpportunityBatch implements Database.Batchable<SObject>{
    public Database.QueryLocator start (Database.BatchableContext bc) {
        // Query all opportunities with StageName = 'Closed Won'
        String query = 'SELECT Id, Amount FROM Opportunity WHERE StageName = \'Closed Won\'';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope){
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        // Iterate over each Opportunity 
        for(SObject sObj : scope) {
            Opportunity opp = (Opportunity)sObj;

            if(opp.Amount > 1000000){
                opp.High_Value__c = true;
            } else {
                opp.High_Value__c = false;
            }
            opportunitiesToUpdate.add(opp);
        }

        // Perform Bulk Update
        if(!opportunitiesToUpdate.isEmpty()){
            update opportunitiesToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch process completed successfully');
    }

}