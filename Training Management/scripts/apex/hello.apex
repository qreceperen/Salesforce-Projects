System.debug('--- SETUP: create a course (fires before/after insert) ---');
Training_Course__c c = new Training_Course__c(Name = 'Bypass Demo');
insert c;
// Expect to see: "TrainingCourseHandler: Before Insert" in the log

System.debug('--- BASELINE: normal update (should run handler) ---');
c.Name = 'Bypass Demo v2';
update c;
// Expect to see: "TrainingCourseHandler: Before Update"

System.debug('--- BYPASS ON: skip the handler ---');
TriggerHandler.bypass('TrainingCourseHandler');
c.Name = 'Bypass Demo v3';
update c;
// Expect to see: NO "TrainingCourseHandler: Before Update" this time
// (Handler is bypassed; execute() returns early.)

System.debug('--- BYPASS OFF: restore normal behavior ---');
TriggerHandler.clearBypass('TrainingCourseHandler');
c.Name = 'Bypass Demo v4';
update c;
// Expect to see: "TrainingCourseHandler: Before Update" again
