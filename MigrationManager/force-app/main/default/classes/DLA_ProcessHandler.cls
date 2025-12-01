// =====================================================
// FILE 6: DLA_ProcessHandler.cls (Simplified)
// =====================================================
public without sharing class DLA_ProcessHandler {
    
    private DLA_Wrapper dlaWrapper;
    private MigrationManager migrationManager;

    public DLA_ProcessHandler(DLA_Wrapper wrapper, MigrationManager manager) {
        dlaWrapper = wrapper;
        migrationManager = manager;
    }
    
    private void executeMigrations() {
        migrationManager.doMigration();
        
        dlaWrapper.getDLA().Migrated_to_nCino__c = true;
        update dlaWrapper.getDLA();
    }

    @AuraEnabled
    public static Map<String, String> run(Id dlaId) {
        Map<String, String> result = new Map<String, String>();
        
        try {
            Digital_Loan_Application__c dla = [
                SELECT Id, Name, Entity__c, Submission_Date__c, 
                       Business_And_DBA_Name__c, Ready_to_Migrate__c, 
                       Migrated_to_nCino__c
                FROM Digital_Loan_Application__c 
                WHERE Id = :dlaId
                LIMIT 1
            ];
            
            DLA_Wrapper wrapper = new DLA_Wrapper(dla);
            
            List<Migratable> migrations = new List<Migratable>{
                new DLA_DemographicsMigration(wrapper)
            };
            
            MigrationManager manager = new MigrationManager(migrations);
            DLA_ProcessHandler proc = new DLA_ProcessHandler(wrapper, manager);

            if(dla.Ready_to_Migrate__c && !dla.Migrated_to_nCino__c) {
                proc.executeMigrations();
                result.put('STATUS', 'SUCCESS');
                result.put('Message', 'Demographics migrated successfully!');
            } else {
                result.put('STATUS', 'FAILURE');
                result.put('Error', 'DLA is not ready to migrate or already migrated');
            }
            
        } catch(Exception e) {
            result.put('STATUS', 'FAILURE');
            result.put('Error', e.getMessage());
            System.debug('Error: ' + e.getMessage());
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        
        return result;
    }
}