List<Task> taskList;
taskList = new List<Task>();

String[] subjects;
String[] statuses;

subjects = new List<String>{ 'Call', 'Email', 'Other' };
statuses = new List<String>{ 'Not Started', 'Completed', 'In Progress' };

for (integer i = 0; i < 30; i++) {
  Task newTask;
  newTask = new Task();
  newTask.Subject = subjects[Math.mod(i, subjects.size())];
  newTask.Status = statuses[Math.mod(i, statuses.size())];
  taskList.add(newTask);
}

insert taskList;
