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
    hotLead.Status = 'Working - Contacted';
    leadsToInsert.add(hotLead);

    // Create Warm Lead
    Lead warmLead;
    warmLead = new Lead();
    warmLead.LastName = 'Warm Lead';
    warmLead.Company = 'Warm Lead Inc';
    warmLead.Industry = 'Technology';
    warmLead.Status = 'Open - Not Contacted';
    leadsToInsert.add(warmLead);

    // create Cold Lead
    Lead coldLead;
    coldLead = new Lead();
    coldLead.LastName = 'Cold Lead';
    coldLead.Company = 'ColdLead Inc';
    coldLead.NumberOfEmployees = 50;
    coldLead.Status = 'Open - Not Contacted';
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
  @isTest
  static void convertedLeadHotLead() {
    // Lead should be converted, Status should be Closed - Converted, Account and Contact should be created.
    //Bring Hot Lead
    List<Lead> hotLead;
    Id hotLeadId;
    String hotLeadRating;

    hotLead = [
      SELECT Id, LastName, Company, Status
      FROM Lead
      WHERE LastName = 'HotLead'
      LIMIT 1
    ];
    hotLeadId = hotLead[0].id;
    hotLeadRating = 'Hot'; // This is given as argument. Because in @TestSetup we need to add Lead without Rating. EvaluateLeadRating method need Lead without Rating. If you do not this way create another lead in Test setup with rating and call.

    // Execute Code
    Test.startTest();
    LeadConversationController.convertedLead(hotLeadId, hotLeadRating);
    Test.stopTest();
    // Assert
    // We expect 1 Account, 1 Contact Related to Account and and Update Lead status as 'Closed - Converted'
    List<Lead> updatedLead;
    List<Account> newAccounts;
    List<Contact> newContacts;

    updatedLead = [SELECT id, Status FROM Lead WHERE id = :hotLeadId];
    newAccounts = [SELECT Id, Name FROM Account WHERE Name = 'Hot Lead Inc'];
    newContacts = [
      SELECT Id, LastName, AccountId
      FROM Contact
      WHERE LastName = 'HotLead'
    ];

    Assert.isTrue(!newAccounts.isEmpty(), 'New Account Should be Created');
    Assert.isTrue(!newContacts.isEmpty(), 'New Contact should be Created');
    Assert.isTrue(!updatedLead.isEmpty(), 'Updated Lead Should exist');

    Assert.areEqual(
      'Closed - Converted',
      updatedLead[0].Status,
      'Lead Status Message Should be Closed - Converted'
    );

    Assert.areEqual(
      'Hot Lead Inc',
      newAccounts[0].Name,
      'Account Name Should match Company Name'
    );

    Assert.areEqual(
      'HotLead',
      newContacts[0].LastName,
      'Contact Last Name should match Lead Lastname'
    );

    Assert.areEqual(
      newAccounts[0].id,
      newContacts[0].AccountId,
      'Account and contact should be related Account.id = contact.accountid'
    );
  }

  @isTest
  static void convertLeadColdLead() {
    // Bring Cold Lead
    List<Lead> coldLeadList;
    Id coldLeadId;
    String coldLeadRating;

    coldLeadList = [
      SELECT Id, LastName, Company, Status
      FROM Lead
      WHERE LastName = 'Cold Lead'
    ];

    coldLeadId = coldLeadList[0].id;
    coldLeadRating = 'Cold';

    // Execute Code
    Test.startTest();
    LeadConversationController.convertedLead(coldLeadId, coldLeadRating);
    Test.stopTest();

    // Assert
    // No Account or Contact Creation, No Lead Status Update
    List<Account> newAccounts;
    List<Contact> newContacts;
    List<Lead> updatedLeadList;

    newAccounts = [SELECT Id FROM Account WHERE Name = 'ColdLead Inc'];
    newContacts = [SELECT Id FROM Contact WHERE LastName = 'Cold Lead'];
    updatedLeadList = [SELECT Id, Status FROM Lead WHERE id = :coldLeadId];

    Assert.isTrue(newAccounts.isEmpty(), 'No new Account should be created');
    Assert.isTrue(newContacts.isEmpty(), 'No new Contact should be created');
    Assert.areEqual(
      'Open - Not Contacted',
      updatedLeadList[0].Status,
      'Lead Status should remain unchanged'
    );
  }
}
