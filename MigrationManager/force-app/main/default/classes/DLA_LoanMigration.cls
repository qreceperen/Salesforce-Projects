public with sharing class DLA_LoanMigration extends DLA_Migration {
    public DLA_LoanMigration(DLA_Wrapper wrapper) {
        super(wrapper);
    }

    public override void migrate() {
        // Access wrapper safely
        DLA_Wrapper wrap = super.getWrapper();
        System.debug('✅ migrate() called for DLA_LoanMigration_Simple');
        System.debug('Wrapper instance: ' + wrap);
        System.debug('DLA Record Id (if any): ' + wrap.getDLA());
    }
}