public class PropertyTriggerHandler extends BaseTriggerHandler {
    protected override void setStrategies() {
        addStrategy('beforeInsert', new PropertyValidationStrategy());
    }
}
