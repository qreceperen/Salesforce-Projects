Property__c prop = [SELECT Id, Status__c FROM Property__c LIMIT 1];
prop.Status__c = 'Inactive';
update prop;