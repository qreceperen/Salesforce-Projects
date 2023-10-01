@isTest
private class LeadConversationControllerTest {
  @TestSetup
  static void setup() {
    // Create a list to hold the new Lead records
    List<Lead> leadsToInsert;
    leadsToInsert = new List<Lead>();

    // Create Hot Lead
    Lead hotLead;
    hotLead = new lead();
    hotLead.LastName = 'HotLead';
    hotLead.Company = 'Hot Lead Inc';
    hotLead.NumberOfEmployees = 200;
    leadsToInsert.add(hotLead);

    // Create Warm Lead
    Lead warmLead;
    warmLead = new Lead();
    warmLead.LastName = 'Warm Lead';
    warmLead.Company = 'Warm Lead Inc';
    warmLead.Industry = 'Technology';
    leadsToInsert.add(warmLead);

    // create Cold Lead
    Lead coldLead;
    coldLead = new Lead();
    coldLead.LastName = 'Cold Lead';
    coldLead.Company = 'ColdLead Inc';
    coldLead.NumberOfEmployees = 50;
    leadsToInsert.add(coldLead);

    insert leadsToInsert;
  }

  @isTest
  static void evaluateLeadRatingHotLead() {
    // Bring Hot Data
    Lead hotLead;
    hotLead = [
      SELECT Id, Lastname, NumberOfEmployees
      FROM Lead
      WHERE NumberOfEmployees = 200
    ];

    // execute
    Test.startTest();
    String actualRating = LeadConversationController.evaluateLeadRating(
      hotLead.id
    );
    Test.stopTest();

    // Assert
    Assert.areEqual(
      'Hot',
      actualRating,
      'The rating should be hot for this lead'
    );
  }
  @isTest
  static void evaluateLeadRatingWarmLead() {
    Lead warmLead;
    warmLead = [SELECT Id, Industry FROM LEAD WHERE Industry = 'Technology'];

    // execute
    Test.startTest();
    String actualRating = LeadConversationController.evaluateLeadRating(
      warmLead.id
    );
    Test.stopTest();

    // assert
    Assert.areEqual(
      'Warm',
      actualRating,
      'The rating should be Warm for this lead'
    );
  }
  @isTest
  static void evaluateLeadRatingColdLead() {
    Lead coldLead;
    coldLead = [
      SELECT Id, NumberOfEmployees
      FROM LEAD
      WHERE NumberOfEmployees = 50
    ];

    // execute
    Test.startTest();
    String actualRating = LeadConversationController.evaluateLeadRating(
      coldLead.id
    );
    Test.stopTest();

    // assert
    Assert.areEqual(
      'Cold',
      actualRating,
      'The rating should be Cold for this lead'
    );
  }
}
