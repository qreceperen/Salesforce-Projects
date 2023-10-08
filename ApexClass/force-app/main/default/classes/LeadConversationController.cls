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

  public static void convertedLead(Id leadId, String leadRating) {
    if (leadRating == 'Hot' || leadRating == 'Warm') {
      // Query the lead Record
      Lead leadRecord;
      leadRecord = [
        SELECT Id, LastName, Company
        FROM Lead
        WHERE Id = :leadId
        WITH SECURITY_ENFORCED
      ];

      // Create  new Account Record
      Account newAccount;
      newAccount = new Account();
      newAccount.Name = leadRecord.Company;
      insert newAccount;

      // Create a new Contact record
      Contact newContact;
      newContact = new Contact();
      newContact.LastName = leadRecord.LastName;
      newContact.AccountId = newAccount.id;
      insert newContact;

      // Update the Lead Record to reflect the conversation
      leadRecord.Status = 'Closed - Converted';
      leadRecord.Rating = leadRating;
      update leadRecord;
    } else {
      Lead leadRecord;
      leadRecord = [
        SELECT Id, LastName, Company
        FROM Lead
        WHERE Id = :leadId
        WITH SECURITY_ENFORCED
      ];
      leadRecord.Rating = 'Cold';
      update leadRecord;
      system.debug('Lead is not ready for conversion ');
    }
  }
}
