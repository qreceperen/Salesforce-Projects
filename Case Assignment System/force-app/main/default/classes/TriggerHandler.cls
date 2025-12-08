/**
 * @description Base class for all trigger handlers
 * Provides common trigger handling functionality and recursion prevention
 */
public virtual class TriggerHandler {
    // Prevents the same handler from running multiple times
    private static Set<String> bypassedHandlers = new Set<String>();

    //Trigger context variables - accesible to child classes
    @TestVisible protected List<SObject> triggerNew;
    @TestVisible protected List<SObject> triggerOld;
    @TestVisible protected Map<Id, SObject> triggerNewMap;
    @TestVisible protected Map<Id, SObject> triggerOldMap;

    // Tracks if handler is currently executing
    private Boolean isExecuting = false;

    // Constructor captures trigger context variables
    public TriggerHandler() {
        this.triggerNew = Trigger.new;
        this.triggerOld = Trigger.old;
        this.triggerNewMap = Trigger.newMap;
        this.triggerOldMap = Trigger.oldMap;
    }

    // Main Entry Point

    public void run() {
    
        // Check if this handler is bypassed
        if(isBypassed()) {
            return; // Exit if bypassed
        }
        
        // Prevent recursion
        if(isExecuting) {
            return;
        }
        isExecuting = true;
        
        // Route to appropriate method based on trigger context
        
        // BEFORE INSERT
        if(Trigger.isBefore && Trigger.isInsert) {
            this.beforeInsert();
        }
        
        // AFTER INSERT
        else if(Trigger.isAfter && Trigger.isInsert) {
            this.afterInsert();
        }
        
        // BEFORE UPDATE
        else if(Trigger.isBefore && Trigger.isUpdate) {
            this.beforeUpdate();
        }
        
        // AFTER UPDATE
        else if(Trigger.isAfter && Trigger.isUpdate) {
            this.afterUpdate();
        }
        
        // BEFORE DELETE
        else if(Trigger.isBefore && Trigger.isDelete) {
            this.beforeDelete();
        }
        
        // AFTER DELETE
        else if(Trigger.isAfter && Trigger.isDelete) {
            this.afterDelete();
        }
        
        // AFTER UNDELETE
        else if(Trigger.isAfter && Trigger.isUndelete) {
            this.afterUndelete();
        }
        
        // Reset execution flag
        isExecuting = false;
    }


    private String getHandlerName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    private Boolean isBypassed() {
        return bypassedHandlers.contains(getHandlerName());
    }

    public static void bypass(String handlerName) {
        bypassedHandlers.add(handlerName);
    }

    public static void clearBypass(String handlerName) {
        bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return bypassedHandlers.contains(handlerName);
    }

    public static void clearAllBypasses() {
        bypassedHandlers.clear();
    }

    // Context Methods - Virtual so they can be overridden
    @TestVisible protected virtual void beforeInsert() {}
    @TestVisible protected virtual void beforeUpdate() {}
    @TestVisible protected virtual void beforeDelete() {}
    @TestVisible protected virtual void afterInsert() {}
    @TestVisible protected virtual void afterUpdate() {}
    @TestVisible protected virtual void afterDelete() {}
    @TestVisible protected virtual void afterUndelete() {}

}