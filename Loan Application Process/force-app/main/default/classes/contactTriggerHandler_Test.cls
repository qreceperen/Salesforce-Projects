@isTest
public with sharing class contactTriggerHandler_Test {
    @isTest
    static void calculateBirthdayInsertUserBeforeToday(){
        // Calculate dates Dynamically
            Date baseDate = Date.today().addyears(-30);
            Date birthdayAfterToday = baseDate.addDays(+1);
            Date birthdayBeforeToday = baseDate.addDays(-1);
        Contact contact = new Contact(
            LastName = 'TestContact1',
            Birthdate = birthdayBeforeToday
        );

        Test.startTest();
            insert contact;
        Test.stopTest();

        // Assert
        Contact retrieveContact = [SELECT Id, Next_Birthday__c FROM Contact WHERE LastName = 'TestContact1' LIMIT 1];
        Date expectedNextBirthDay = birthdayBeforeToday.addYears(Date.today().year() - birthdayBeforeToday.year() +1);
        Assert.areEqual(expectedNextBirthDay, retrieveContact.Next_Birthday__c, 'Failed');

    }
}