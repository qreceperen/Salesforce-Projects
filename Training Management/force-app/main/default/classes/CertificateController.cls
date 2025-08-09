public with sharing class CertificateController {

  /**
   * Returns certificates for the given customer.
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

  /**
   * Manually generates a certificate for a given enrollment.
   */
  @AuraEnabled
  public static void generateCertificate(Id enrollmentId) {
    try {
      Training_Enrollment__c enrollment = [
        SELECT Id, Customer__c, Training_Course__c,
               Training_Course__r.Name, Customer__r.Name
        FROM Training_Enrollment__c
        WHERE Id = :enrollmentId LIMIT 1
      ];

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
    } catch (Exception e) {
      throw new AuraHandledException('Failed to generate certificate: ' + e.getMessage());
    }
  }

  /**
   * Returns a summary of certificate counts by status and expiry.
   */
  @AuraEnabled(cacheable=true)
  public static Map<String, Integer> getCertificateStats(Id customerId) {
    if (customerId == null) {
      return new Map<String, Integer>();
    }

    List<Training_Certificate__c> certificates = [
      SELECT Status__c, Expiry_Date__c
      FROM Training_Certificate__c
      WHERE Customer__c = :customerId
    ];

    Integer total = certificates.size();
    Integer valid = 0;
    Integer expired = 0;
    Integer expiringSoon = 0;

    Date thirtyDaysFromNow = Date.today().addDays(30);

    for (Training_Certificate__c cert : certificates) {
      if (cert.Status__c == 'Valid') {
        valid++;
        if (cert.Expiry_Date__c != null && cert.Expiry_Date__c <= thirtyDaysFromNow) {
          expiringSoon++;
        }
      } else if (cert.Status__c == 'Expired') {
        expired++;
      }
    }

    Map<String, Integer> stats = new Map<String, Integer>();
    stats.put('total', total);
    stats.put('valid', valid);
    stats.put('expired', expired);
    stats.put('expiringSoon', expiringSoon);

    return stats;
  }

  /**
   * Renews a certificate by updating its status and dates.
   */
  @AuraEnabled
  public static void renewCertificate(Id certificateId) {
    try {
      Training_Certificate__c certificate = new Training_Certificate__c(
        Id = certificateId,
        Status__c = 'Valid',
        Issue_Date__c = Date.today(),
        Expiry_Date__c = Date.today().addYears(2)
      );
      update certificate;
    } catch (Exception e) {
      throw new AuraHandledException('Failed to renew certificate: ' + e.getMessage());
    }
  }
}