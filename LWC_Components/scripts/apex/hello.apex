<<<<<<< HEAD
List<PermissionSetAssignment> getPerm = UserPermissionSetController.getUserPermissionSets('User');

for(PermissionSetAssignment p : getPerm) {
    system.debug(p.Assignee.Name + '---' + p.PermissionSet.Name);

}
=======
// List<Case> allCases = [SELECT Id, CaseNumber, Subject, Status, Priority, Owner.Name FROM Case];
// system.debug(allCases);

List<String> test = OpportunityService.getOpportunityStagePicklistValues();
system.debug(test);
>>>>>>> 48e3603e09f2ec22fdab9955d492284a8e40b11f
