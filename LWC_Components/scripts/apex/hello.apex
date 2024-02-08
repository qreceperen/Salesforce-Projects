List<PermissionSetAssignment> getPerm = UserPermissionSetController.getUserPermissionSets('User');

for(PermissionSetAssignment p : getPerm) {
    system.debug(p.Assignee.Name + '---' + p.PermissionSet.Name);

}