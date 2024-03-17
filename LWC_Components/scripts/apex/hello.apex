<<<<<<< HEAD
List<PermissionSetAssignment> getPerm = UserPermissionSetController.getUserPermissionSets('User');

for(PermissionSetAssignment p : getPerm) {
    system.debug(p.Assignee.Name + '---' + p.PermissionSet.Name);

}
=======
Map<String, Object> oppData = new Map<String, Object>();
oppData.put('Name', 'Test Opportunity');
oppData.put('Amount', '50000');
oppData.put('CloseDate', '2024-01-01');
oppData.put('StageName', 'Prospecting');
oppData.put('Description', 'This is a test description for the new opportunity.');

Id newOppId = OpportunityService.createOpportunity(oppData);
System.debug('New Opportunity Id: ' + newOppId);

>>>>>>> 48e3603e09f2ec22fdab9955d492284a8e40b11f
