public abstract class DLA_Migration implements Migratable {
    private final DLA_Wrapper w;

    public DLA_Migration(DLA_Wrapper wrapper) {
        System.debug('DLA_Migration: constructor started');
        if(wrapper == null) {
            System.debug('DLA_Migration: wrapper is null, throwing exception');
            throw new DLA_MigrationException('Wrapper parameter cannot be null');
        }
        w = wrapper;
        System.debug('DLA_Migration: wrapper assigned for DLA Id -> ' + w.getDLA().Id);
    }

    public abstract void migrate();

    protected DLA_Wrapper getWrapper() {
        System.debug('DLA_Migration: getWrapper() called, returning wrapper for DLA Id -> ' + w.getDLA().Id);
        return w;
    }

    public class DLA_MigrationException extends Exception {}
}
