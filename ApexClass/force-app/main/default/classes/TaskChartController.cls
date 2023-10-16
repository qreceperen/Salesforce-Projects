public with sharing class TaskChartController {
  public static Integer getTotalTaskCount() {
    Integer totalNumberOfTask;
    totalNumberOfTask = [SELECT COUNT() FROM Task];
    return totalNumberOfTask;
  }
}
