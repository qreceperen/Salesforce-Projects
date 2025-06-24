/**
 * TriggerContext - Holds all trigger context information
 * Provides a centralized way to access trigger variables
 */
public class TriggerContext {
    public List<SObject> newRecords { get; private set; }
    public List<SObject> oldRecords { get; private set; }
    public Map<Id, SObject> newMap { get; private set; }
    public Map<Id, SObject> oldMap { get; private set; }
    public Boolean isInsert { get; private set; }
    public Boolean isUpdate { get; private set; }
    public Boolean isDelete { get; private set; }
    public Boolean isUndelete { get; private set; }
    public Boolean isBefore { get; private set; }
    public Boolean isAfter { get; private set; }
    public Integer size { get; private set; }
    
    private static TriggerContext instance;
    
    private TriggerContext() {
         System.debug('⚙️ Constructing TriggerContext');
        this.newRecords = Trigger.new;
        this.oldRecords = Trigger.old;
        this.newMap = Trigger.newMap;
        this.oldMap = Trigger.oldMap;
        this.isInsert = Trigger.isInsert;
        this.isUpdate = Trigger.isUpdate;
        this.isDelete = Trigger.isDelete;
        this.isUndelete = Trigger.isUndelete;
        this.isBefore = Trigger.isBefore;
        this.isAfter = Trigger.isAfter;
        this.size = Trigger.size;
    }
    
    public static TriggerContext getInstance() {
        if (instance == null) {
            instance = new TriggerContext();
        }
        return instance;
    }
    
    public static void clearInstance() {
        instance = null;
    }

}