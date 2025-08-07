public class UnitTriggerHandler extends BaseTriggerHandler {

    protected override void setStrategies() {
        System.debug('🧭 UnitTriggerHandler.setStrategies() running');

        // Validation logic
        addStrategy('beforeInsert', new UnitValidationStrategy());
        addStrategy('beforeUpdate', new UnitValidationStrategy());

        // Property unit count update
        addStrategy('afterInsert', new UnitPropertyUpdateStrategy());
        addStrategy('afterDelete', new UnitPropertyUpdateStrategy());
        addStrategy('afterUndelete', new UnitPropertyUpdateStrategy());

        // Status change handling
        addStrategy('afterUpdate', new UnitStatusChangeStrategy());
    }
}
