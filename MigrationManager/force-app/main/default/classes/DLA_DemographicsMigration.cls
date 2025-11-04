// =====================================================
// FILE 5: DLA_DemographicsMigration.cls
// =====================================================
public class DLA_DemographicsMigration extends DLA_Migration {
    
    public DLA_DemographicsMigration(DLA_Wrapper wrapper) {
        super(wrapper);
    }

    public override void migrate() {
        List<MTB_Demographics__c> demos = new List<MTB_Demographics__c>();
        
        List<MTB_Demographics__c> existingDemos = [
            SELECT Id 
            FROM MTB_Demographics__c 
            WHERE Digital_Loan_Application__c = :super.getWrapper().getDLA().Id
        ];
        
        if(!existingDemos.isEmpty()) {
            for(MTB_Demographics__c d : existingDemos) {
                MTB_Demographics__c demo = new MTB_Demographics__c(Id = d.Id);
                
                demo.Date_Form_Received__c = super.getWrapper().getDLA().Submission_Date__c;
                demo.Application_Method__c = 'Online';
                demo.Legal_Business_Applicant_Name__c = super.getWrapper().getDLA().Business_And_DBA_Name__c;
                demo.Record_Source__c = 'nCino';
                demo.Origination_System__c = 'nCinooOoOoO';
                
                demos.add(demo);
            }
            update demos;
        }
    }
}