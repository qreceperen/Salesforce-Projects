public class TrainingCourseHandler extends TriggerHandler {
    
    // Example: only override beforeInsert for now
    protected override void beforeInsert() {
        System.debug('TrainingCourseHandler: Before Insert fired!');
    }

    
}
