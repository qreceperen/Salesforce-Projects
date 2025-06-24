// =============================================================================
// PROPERTY TRIGGER FRAMEWORK
// =============================================================================

/**
 * PropertyTriggerHandler - Main handler for Property__c triggers
 */
public class PropertyTriggerHandler extends BaseTriggerHandler {
    
    protected override void setStrategies() {
        System.debug('🚦 PropertyTriggerHandler: setting strategies');
        addStrategy('beforeInsert', new PropertyValidationStrategy());
        addStrategy('beforeUpdate', new PropertyValidationStrategy());
        addStrategy('afterInsert', new PropertyInitializationStrategy());
        addStrategy('afterUpdate', new PropertyUpdateCascadeStrategy());
        
    }
}