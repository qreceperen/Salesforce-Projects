public with sharing class UserPermissionSetController {
    @AuraEnabled (cacheable = true) // Since this involves search, we're not caching the results
    public static List<PermissionSetAssignment> getUserPermissionSets(
        String searchKey
    ) {
        String searchKeyword = '%' + searchKey + '%';
        List<PermissionSetAssignment> assignedPermSet = [
            SELECT Id, PermissionSet.Name, PermissionSetId, Assignee.Name
            FROM PermissionSetAssignment
            WHERE
                Assignee.Name LIKE :searchKeyword
                OR Assignee.Username LIKE :searchKeyword
        ];

        return assignedPermSet;
    }
}
