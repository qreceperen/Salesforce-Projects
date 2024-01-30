// List<Case> allCases = [SELECT Id, CaseNumber, Subject, Status, Priority, Owner.Name FROM Case];
// system.debug(allCases);

List<String> test = OpportunityService.getOpportunityStagePicklistValues();
system.debug(test);