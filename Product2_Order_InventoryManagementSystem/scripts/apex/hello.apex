List<Account> accList = [SELECT Id FROM Account];
Set<id> accIds = new Set<Id>();
for (Account acc : accList) {
  accIds.add(acc.id);
}

mapPractice.getAccount(accIds);
