List<Inventory_Setting__mdt> invMetaData = [
  SELECT DeveloperName, Label, Low_Quantity_Alert__c
  FROM Inventory_Setting__mdt
];
system.debug(invMetaData);
