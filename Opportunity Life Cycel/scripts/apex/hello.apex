Opportunity singleOpp;
Opportunity returnedOpp;
List<Task> taskList;
String expectedDescription;

// Data
// Add an Opportunity
singleOpp = new Opportunity(
  Name = 'Test 1',
  StageName = 'Prospecting',
  CloseDate = system.date.today().addDays(30)
);
insert singleOpp;

//Update Opportunity to Run Trigger
returnedOpp = [
  SELECT Id, StageName
  FROM Opportunity
  WHERE Id = :singleOpp.id
  LIMIT 1
];

returnedOpp.StageName = 'Qualification';
update returnedOpp;

// Assert Task Created
taskList = [SELECT Id, Subject, Description FROM Task];

for (Task t : taskList) {
  system.debug('DESCRIPTIONS ' + t.Description);
}
