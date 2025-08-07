public class LeaseTriggerHandler extends BaseTriggerHandler {
    protected override void setStrategies() {
        addStrategy('beforeInsert', new LeaseValidationStrategy());
        addStrategy('beforeUpdate', new LeaseValidationStrategy());
        addStrategy('afterInsert', new LeaseUnitOccupancyStrategy());
        addStrategy('afterUpdate', new LeaseStatusChangeStrategy());
        // addStrategy('afterDelete', new LeaseDeleteCleanupStrategy()); // later
    }
}
