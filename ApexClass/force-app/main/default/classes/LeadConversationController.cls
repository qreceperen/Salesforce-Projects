public with sharing class LeadConversationController {
  // Method to evaluate and assign a rating to the lead
  public static String evaluateLeadRating(Id leadId) {
    Lead leadRecord;
    String rating;
    leadRecord = [
      SELECT Id, LeadSource, Industry, Company, NumberOfEmployees
      FROM Lead
      WHERE Id = :leadId
      WITH SECURITY_ENFORCED
    ];

    // Assign a rating based on arbittrary criteria
    if (leadRecord.NumberOfEmployees > 100) {
      rating = 'Hot';
    } else if (leadRecord.Industry == 'Technology') {
      rating = 'Warm';
    } else {
      rating = 'Cold';
    }
    return rating;
  }
}
