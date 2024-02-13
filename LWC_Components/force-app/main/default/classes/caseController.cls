public with sharing class caseController {
    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(String searchTerm) {
        // Local Variables
        String searchKeyword;
        List<Case> caseList;

        searchKeyword = '%' + searchTerm + '%';
        caseList = [
            SELECT Id, CaseNumber, Subject, Status, Priority, Owner.Name
            FROM Case
            WHERE CaseNumber LIKE :searchKeyword OR Subject LIKE :searchKeyword
            ORDER BY CreatedDate DESC
        ];

        return caseList;
    }

    @AuraEnabled
    public static Case updateCaseStatus(String caseId, String newStatus) {
        Case caseToUpdate = [SELECT Id, Status FROM Case WHERE Id = :caseId];
        caseToUpdate.Status = newStatus;
        update caseToUpdate;
        return caseToUpdate;
    }
}
