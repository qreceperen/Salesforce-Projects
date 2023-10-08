public with sharing class TaskAutomationController {
  public static void updateTaskStatus(List<Task> tasks) {
    Date today;
    List<Task> taskToUpdate;

    taskToUpdate = new List<Task>();
    today = Date.today();
    for (Task t : tasks) {
      if (today > t.ActivityDate) {
        t.Status = 'Completed';
        taskToUpdate.add(t);
      }
    }
    update taskToUpdate;
  }
}
