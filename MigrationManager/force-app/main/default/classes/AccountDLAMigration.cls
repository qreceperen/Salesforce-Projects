// THIS IS A TEST MIGRATION DELETE CLASS AFTER PRACTICE

public with sharing class AccountDLAMigration extends DLA_Migration {
    public AccountDLAMigration(DLA_Wrapper wrapper) {
        super(wrapper); // Pass wrapper to parent
    }

    public override void migrate() {
        // Always ask parent for wrapper
        DLA_Wrapper w = getWrapper();

        //Example migration Logic using wrapper data
        System.debug('Account Migration → Business=' + w.getBusiness().Name);
        System.debug('Account Migration → Loan Info=' + w.getLoan().Tax_Exempt__c);
        System.debug('Account Migration → DLA Status=' + w.getDLA().Status__c);

        // Example: Insert Account 
        Account acc = new Account(Name =w.getBusiness().Name + ' Inc.', Type = 'Prospect', Description = w.getLoan().Tax_Exempt__c + ' --- ' + w.getDLA().Status__c );
        insert acc;

        System.debug('Inserted Account Id: ' + acc.Id);

    }


}