/**
 * Abstract base class for all trigger handlers
 * Provides a consistent framework for trigger processing
 */
public abstract class TriggerHandler {
    
    // Static map to prevent recursive trigger execution
    private static Map<String, Boolean> bypassMap = new Map<String, Boolean>();
    
    // Instance variable to track handler type
    private String handlerName;
    
    /**
     * Constructor - automatically sets handler name
     */
    public TriggerHandler() {
        this.handlerName = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }
    
    /**
     * Main entry point - called from triggers
     */
    public void execute() {
        // Check if this handler should be bypassed
        if (isBypassed()) {
            return;
        }
        
        // Execute appropriate context methods
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                beforeInsert();
            } else if (Trigger.isUpdate) {
                beforeUpdate();
            } else if (Trigger.isDelete) {
                beforeDelete();
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                afterInsert();
            } else if (Trigger.isUpdate) {
                afterUpdate();
            } else if (Trigger.isDelete) {
                afterDelete();
            } else if (Trigger.isUndelete) {
                afterUndelete();
            }
        }
    }
    
    /**
     * Virtual methods for each trigger context
     * Override in child classes as needed
     */
    protected virtual void beforeInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void beforeDelete() {}
    protected virtual void afterInsert() {}
    protected virtual void afterUpdate() {}
    protected virtual void afterDelete() {}
    protected virtual void afterUndelete() {}
    
    /**
     * Bypass mechanism to prevent recursive triggers
     */
    public static void bypass(String handlerName) {
        bypassMap.put(handlerName, true);
    }
    
    public static void clearBypass(String handlerName) {
        bypassMap.remove(handlerName);
    }
    
    public static void clearAllBypasses() {
        bypassMap.clear();
    }
    
    public Boolean isBypassed() {
        return bypassMap.containsKey(this.handlerName);
    }
}