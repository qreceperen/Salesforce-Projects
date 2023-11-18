List<Task> taskList = [SELECT Id FROM Task];
// delete taskList;
for (Task t : taskList) {
  system.debug(t);
}
