// =====================================================
// FILE 3: MigrationManager.cls
// =====================================================
public with sharing class MigrationManager {
    private List<Migratable> migrations;

    public MigrationManager(List<Migratable> migClasses) {
        migrations = migClasses;
    }

    public void doMigration() {
        for(Migratable mig: migrations) {
            mig.migrate();
        }
    }
}