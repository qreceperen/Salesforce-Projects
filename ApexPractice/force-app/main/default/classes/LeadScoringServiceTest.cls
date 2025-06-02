@IsTest
public class LeadScoringServiceTest {
    
    @IsTest
    static void testLeadScoringHappyPath() {
        // Step 1: Create a test lead that matches ALL our metadata rules
        Lead testLead = new Lead();
        testLead.FirstName = 'Test';
        testLead.LastName = 'Lead';
        testLead.Company = 'Test Company';
        testLead.Email = 'test@example.com';
        
        // Set values to match our 6 metadata rules:
        testLead.Industry = 'Technology';                    // Matches: Industry = Technology
        testLead.Company_Size__c = 'Enterprise (2000+)';     // Matches: Company_Size = Enterprise  
        testLead.Email_Opens__c = 8;                         // Matches: Email_Opens > 5
        testLead.Website_Visits__c = 15;                     // Matches: Website_Visits > 10
        testLead.Budget_Range__c = '100K-500K';              // Matches: Budget_Range = 100K-500K
        testLead.Status = 'Working - Contacted';             // Matches: Status = Working - Contacted
        
        // Step 2: Execute the scoring logic
        Test.startTest();
        LeadScoringService.calculateScoresForLeads(new List<Lead>{testLead});
        Test.stopTest();
        
        // Step 3: Verify the results using Assert class
        Assert.isNotNull(testLead.Lead_Score__c, 'Lead Score should be calculated');
        Assert.isTrue(testLead.Lead_Score__c > 0, 'Lead Score should be greater than 0');

        Assert.isNotNull(testLead.Demographic_Score__c, 'Demographic Score should be calculated');
        Assert.isTrue(testLead.Demographic_Score__c > 0, 'Demographic Score should be greater than 0');

        Assert.isNotNull(testLead.Behavioral_Score__c, 'Behavioral Score should be calculated');  
        Assert.isTrue(testLead.Behavioral_Score__c > 0, 'Behavioral Score should be greater than 0');

        Assert.isNotNull(testLead.Engagement_Score__c, 'Engagement Score should be calculated');
        Assert.isTrue(testLead.Engagement_Score__c > 0, 'Engagement Score should be greater than 0');

        Assert.isNotNull(testLead.Score_Last_Updated__c, 'Score Last Updated should be set');

        // Verify total score equals sum of category scores
        Decimal expectedTotal = testLead.Demographic_Score__c + testLead.Behavioral_Score__c + testLead.Engagement_Score__c;
        Assert.areEqual(expectedTotal, testLead.Lead_Score__c, 'Total score should equal sum of category scores');

        System.debug('=== TEST RESULTS ===');
        System.debug('Lead Score: ' + testLead.Lead_Score__c);
        System.debug('Demographic: ' + testLead.Demographic_Score__c);
        System.debug('Behavioral: ' + testLead.Behavioral_Score__c);
        System.debug('Engagement: ' + testLead.Engagement_Score__c);
    }
}