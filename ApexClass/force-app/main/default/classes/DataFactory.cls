public with sharing class DataFactory {
  public static List<Opportunity> createOpportunity(
    Integer numberOfOpportunity
  ) {
    List<Opportunity> insertOppList;
    insertOppList = new List<Opportunity>();

    for (Integer i = 0; i < numberOfOpportunity; i++) {
      Opportunity opp;
      opp = new Opportunity();
      opp.Name = 'Test Opportunity ' + i;
      opp.CloseDate = date.today().addDays(30);
      opp.StageName = 'Prospecting';
      insertOppList.add(opp);
    }
    insert insertOppList;
    return insertOppList;
  }
}
