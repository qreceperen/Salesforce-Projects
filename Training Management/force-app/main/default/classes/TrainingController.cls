public with sharing class TrainingController {

  /**
   * Returns all active training courses for listing in the dashboard.
   */
  @AuraEnabled(cacheable=true)
  public static List<Training_Course__c> getActiveCourses() {
    return [
      SELECT Id, Name, Description__c, Duration_Hours__c, Category__c,
             Start_Date__c, End_Date__c, Max_Capacity__c,
             (SELECT Id FROM Training_Enrollments__r)
      FROM Training_Course__c
      WHERE Status__c = 'Active'
      ORDER BY Start_Date__c
    ];
  }

  /**
   * Enrolls a customer in a course by creating a Training_Enrollment__c record.
   */
  @AuraEnabled
  public static String enrollCustomerInCourse(Id courseId, Id customerId) {
    try {
      Training_Enrollment__c enrollment = new Training_Enrollment__c(
        Customer__c = customerId,
        Training_Course__c = courseId,
        Enrollment_Date__c = Date.today(),
        Status__c = 'Enrolled'
      );
      insert enrollment;
      return 'Success';
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  /**
   * Searches for contacts by name or email.
   */
  @AuraEnabled(cacheable=true)
  public static List<Contact> getCustomers(String searchTerm) {
    String searchKey = '%' + searchTerm + '%';
    return [
      SELECT Id, Name, Email, Account.Name
      FROM Contact
      WHERE Name LIKE :searchKey OR Email LIKE :searchKey
      LIMIT 10
    ];
  }

  /**
   * Retrieves all enrollments for a given customer.
   */
  @AuraEnabled(cacheable=true)
  public static List<Training_Enrollment__c> getCustomerEnrollments(Id customerId) {
    if (customerId == null) {
      return new List<Training_Enrollment__c>();
    }

    return [
      SELECT Id, Training_Course__r.Name, Status__c, Progress_Percentage__c,
             Enrollment_Date__c, Completion_Date__c, Grade__c, Comments__c,
             Training_Course__r.Id, Training_Course__r.Category__c, Training_Course__r.Duration_Hours__c
      FROM Training_Enrollment__c
      WHERE Customer__c = :customerId
      ORDER BY Enrollment_Date__c DESC
    ];
  }

  /**
   * Returns upcoming courses the customer is enrolled in.
   */
  @AuraEnabled(cacheable=true)
  public static List<Training_Course__c> getUpcomingCourses(Id customerId) {
    if (customerId == null) {
      return new List<Training_Course__c>();
    }

    Set<Id> enrolledCourseIds = new Set<Id>();
    for (Training_Enrollment__c enrollment : [
      SELECT Training_Course__c
      FROM Training_Enrollment__c
      WHERE Customer__c = :customerId AND Status__c IN ('Enrolled', 'In Progress')
    ]) {
      enrolledCourseIds.add(enrollment.Training_Course__c);
    }

    return [
      SELECT Id, Name, Description__c, Category__c, Start_Date__c,
             End_Date__c, Duration_Hours__c
      FROM Training_Course__c
      WHERE Id IN :enrolledCourseIds AND Start_Date__c >= TODAY AND Status__c = 'Active'
      ORDER BY Start_Date__c ASC
    ];
  }

  /**
   * Updates progress percentage and status for a training enrollment.
   * If progress is 100%, marks it completed and triggers certificate creation.
   */
  @AuraEnabled
  public static void updateEnrollmentProgress(Id enrollmentId, Decimal progressPercentage) {
    try {
      System.debug('Updating progress to: ' + progressPercentage);
      Training_Enrollment__c enrollment = new Training_Enrollment__c(
        Id = enrollmentId,
        Progress_Percentage__c = progressPercentage
      );

      if (progressPercentage == 0) {
        enrollment.Status__c = 'Enrolled';
      } else if (progressPercentage == 100) {
        enrollment.Status__c = 'Completed';
        enrollment.Completion_Date__c = Date.today();
      } else {
        enrollment.Status__c = 'In Progress';
      }

      update enrollment;

      if (progressPercentage == 100) {
        System.debug('Generate Certificate Later');
        // generateCertificateForEnrollment(enrollmentId);
      }
    } catch (Exception e) {
      System.debug('Error updating progress: ' + e.getMessage());
    }
  }

  /**
   * Automatically generates a certificate for a completed enrollment.
   */
  @AuraEnabled
  public static void generateCertificateForEnrollment(Id enrollmentId) {
    try {
      Training_Enrollment__c enrollment = [
        SELECT Id, Customer__c, Training_Course__c, Training_Course__r.Name, Customer__r.Name
        FROM Training_Enrollment__c
        WHERE Id = :enrollmentId LIMIT 1
      ];

      List<Training_Certificate__c> existingCerts = [
        SELECT Id
        FROM Training_Certificate__c
        WHERE Customer__c = :enrollment.Customer__c AND Training_Course__c = :enrollment.Training_Course__c
      ];

      if (existingCerts.isEmpty()) {
        Training_Certificate__c certificate = new Training_Certificate__c(
          Name = enrollment.Training_Course__r.Name + ' - ' + enrollment.Customer__r.Name,
          Customer__c = enrollment.Customer__c,
          Training_Course__c = enrollment.Training_Course__c,
          Issue_Date__c = Date.today(),
          Expiry_Date__c = Date.today().addYears(2),
          Certificate_Number__c = 'CERT-' + String.valueOf(System.now().getTime()),
          Status__c = 'Valid'
        );
        insert certificate;
      } else {
        System.debug('Already exists');
      }
    } catch (Exception e) {
      System.debug('Error generating certificate: ' + e.getMessage());
    }
  }

  /**
   * Returns a summary of training stats for a customer (total, completed, progress, etc).
   */
  @AuraEnabled(cacheable=true)
  public static Map<String, Object> getCustomerTrainingStats(Id customerId) {
    if (customerId == null) {
      return new Map<String, Object>();
    }

    List<Training_Enrollment__c> enrollments = [
      SELECT Status__c, Progress_Percentage__c
      FROM Training_Enrollment__c
      WHERE Customer__c = :customerId
    ];

    Integer total = enrollments.size();
    Integer completed = 0;
    Integer inProgress = 0;
    Integer cancelled = 0;
    Decimal totalProgress = 0;

    for (Training_Enrollment__c enrollment : enrollments) {
      if (enrollment.Status__c == 'Completed') {
        completed++;
      } else if (enrollment.Status__c == 'In Progress' || enrollment.Status__c == 'Enrolled') {
        inProgress++;
      } else if (enrollment.Status__c == 'Cancelled') {
        cancelled++;
      }

      if (enrollment.Progress_Percentage__c != null) {
        totalProgress += enrollment.Progress_Percentage__c;
      }
    }

    Decimal averageProgress = total > 0 ? totalProgress / total : 0;
    Decimal completionRate = total > 0 ? (completed * 100.0) / total : 0;

    Map<String, Object> stats = new Map<String, Object>();
    stats.put('totalEnrollments', total);
    stats.put('completedCourses', completed);
    stats.put('inProgressCourses', inProgress);
    stats.put('cancelledCourses', cancelled);
    stats.put('averageProgress', averageProgress.setScale(1));
    stats.put('completionRate', completionRate.setScale(1));

    return stats;
  }

  /**
   * Returns all training certificates for a given customer.
   */
  @AuraEnabled(cacheable=true)
  public static List<Training_Certificate__c> getCustomerCertificates(Id customerId) {
    if (customerId == null) {
      return new List<Training_Certificate__c>();
    }

    return [
      SELECT Id, Name, Training_Course__r.Name, Issue_Date__c,
             Expiry_Date__c, Status__c, Certificate_Number__c,
             Training_Course__r.Category__c
      FROM Training_Certificate__c
      WHERE Customer__c = :customerId
      ORDER BY Issue_Date__c DESC
    ];
  }
} 