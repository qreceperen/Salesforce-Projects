List<Task> taskList;
taskList = [SELECT Id, ActivityDate, Status FROM Task];
for (Task t : taskList) {
  system.debug('Date before decrement -- ' + t.ActivityDate);
  Date updatedActivityDate;
  updatedActivityDate = t.ActivityDate;
  updatedActivityDate -= 1;

  system.debug('Date after decrement -- ' + updatedActivityDate);
}
// TaskAutomationController.updateTaskStatus(taskList);
