Set<String> ACTIVE_STATUSES = new Set<String>{'Enrolled', 'In Progress'};
List<Training_Enrollment__c> enrollmentList = [SELECT Id, Training_Course__c, Status__c FROM Training_Enrollment__c];
Set<Id> courseIds = new Set<Id>();

for(Training_Enrollment__c enrollment : enrollmentList) {
    if(ACTIVE_STATUSES.contains(enrollment.Status__c))
        courseIds.add(enrollment.Training_Course__c);
}




Map<Id, Training_Course__c> courseMap = new Map<Id, Training_Course__c>([
    SELECT Id, Name, Max_Capacity__c,
           (SELECT Id, Name FROM Training_Enrollments__r WHERE Status__c IN :ACTIVE_STATUSES)
    FROM Training_Course__c 
    WHERE Id IN :courseIds]);


    for (Training_Course__c c : courseMap.values()) {
        System.debug('Course: ' + c.Name + ' | Capacity: ' + c.Max_Capacity__c);
        for (Training_Enrollment__c e : c.Training_Enrollments__r) {
            System.debug('   Enrollment: ' + e.Id + ' - ' + e.Name);
        }
    }


