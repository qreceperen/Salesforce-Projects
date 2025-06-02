public with sharing class TriggerHandler {
    public static void handleTrigger(List<Lead> listOfLeads){
        LeadScoringService.calculateScoresForLeads(listOfLeads);
    }
}