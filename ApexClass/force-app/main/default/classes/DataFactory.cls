public class deploy {

  public static void post_deployment_steps() {
      // Pre-existing setup, do not change
      cstmUserPermissions__c cup = cstmUserPermissions__c.getInstance(UserInfo.getUserId());
      cup.IsComputeNNF__c = false;
      cup.No_Flow__c = true;
      cup.No_Trigger__c = true;
      cup.No_Validation__c = true;
      cup.No_Workflow__c = true;
      upsert cup;
      
      new triggerRegistrationProvider().run();
      
      // Assign Perm Set
      assignNcinoToolsCorePermissionSet();
  }

  public static void post_deployment_steps_with_trigger() {
      // Pre-existing setup, do not change
      cstmUserPermissions__c cup = cstmUserPermissions__c.getInstance(UserInfo.getUserId());
      cup.IsComputeNNF__c = false;
      cup.No_Flow__c = true;
      cup.No_Trigger__c = false;
      cup.No_Validation__c = true;
      cup.No_Workflow__c = true;
      upsert cup;
      
      new triggerRegistrationProvider().run();
      
      // Further steps if needed
  }

  public static void assignNcinoToolsCorePermissionSet() {
      PermissionSet nCinoToolsCore;
      Set<String> lanIds;
      List<User> usersToAssign;
      Set<Id> userIds;
      Set<Id> usersWithPermSet;

      // Retrieve the Permission Set ID for 'nCinoTools_Core'
      nCinoToolsCore = [SELECT Id FROM PermissionSet WHERE Name = 'nCinoTools_Core' LIMIT 1];

      // Define the LAN_IDs of the users
      lanIds = new Set<String>{
          'EBLSRPS', 'EBLSSH7', 'EBLSNI0', 'EBLSRR0', 'EBLSDTS', 
          'EBLSEL0', 'EBLSSS7', 'EBLSBH6', 'EBRNQPY'
      };

      // Query existing PermissionSet Assignments for 'nCinoTools_Core'
      usersWithPermSet = new Set<Id>();
      for (PermissionSetAssignment psa : [
          SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :nCinoToolsCore.id
      ]) {
          usersWithPermSet.add(psa.AssigneeId);
      }

      // Query users based on LAN_ID__c and exclude those who already have the permset
      usersToAssign = [
          SELECT Id FROM User WHERE LAN_ID__c IN :lanIds AND isActive = TRUE AND Id NOT IN :usersWithPermSet
      ];

      // Collect User IDs
      userIds = new Set<Id>();
      for (User usr : usersToAssign) {
          userIds.add(usr.Id);
      }

      // Call the @future method to handle PermissionSetAssignment insertion
      if (!userIds.isEmpty()) {
          assignPermissionSetToUsers(userIds, nCinoToolsCore.Id);
      }
  }

  @future
  public static void assignPermissionSetToUsers(Set<Id> userIds, Id permSetId) {
      List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
      for (Id userId : userIds) {
          assignments.add(new PermissionSetAssignment(PermissionSetId = permSetId, AssigneeId = userId));
      }

      if (!assignments.isEmpty()) {
          try {
              insert assignments;
          } catch (DmlException e) {
              System.debug(LoggingLevel.ERROR, 'Failed to assign Permission Set: ' + e.getMessage());
              // Implement more robust error handling as needed
          }
      }
  }
}
