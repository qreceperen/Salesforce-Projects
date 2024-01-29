// List<Case> allCases = [SELECT Id, CaseNumber, Subject, Status, Priority, Owner.Name FROM Case];
// system.debug(allCases);

List<Case> filteredCase = caseController.getCases('Repeat');
system.debug(filteredCase);