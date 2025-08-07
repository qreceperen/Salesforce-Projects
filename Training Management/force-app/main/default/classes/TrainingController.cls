public with sharing class TrainingController {
    @AuraEnabled(cacheable=true)
    public static List<Training_Course__c> getActiveCourses(){
        return [
            SELECT 
                Id, 
                Name, 
                Description__c, 
                Duration_Hours__c, 
                Category__c, 
                Start_Date__c, 
                End_Date__c, 
                Max_Capacity__c,
                (SELECT Id FROM Training_Enrollments__r)
            FROM Training_Course__c
            WHERE Status__c = 'Active'
            ORDER BY Start_Date__c
        ];
    }

    @AuraEnabled
    public static String enrollCustomerInCourse(Id courseId, Id customerId) {
        try {
            Training_Enrollment__c enrollment = new Training_Enrollment__c(
                Customer__c = customerId,
                Training_Course__c  = courseId,
                Enrollment_Date__c = Date.today(),
                Status__c = 'Enrolled'
            );
            insert enrollment;
            return 'Success';

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}