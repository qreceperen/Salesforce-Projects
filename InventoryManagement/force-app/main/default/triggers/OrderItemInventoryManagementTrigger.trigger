trigger OrderItemInventoryManagementTrigger on Order_Item__c(
  before insert,
  after insert
) {
  if (Trigger.isAfter && Trigger.isInsert) {
    List<Order_Item__c> orderedItems = Trigger.New;

    // Collect All Inventory Product Ids
    Set<Id> InventoryProductIds = new Set<Id>();
    for (Order_Item__c orderItem : orderedItems) {
      InventoryProductIds.add(orderItem.Inventory_Product__c);
    }

    // Query and Keep related Inventory records
    Map<Id, Inventory_Product__c> relatedInventoryProductMap = new Map<Id, Inventory_Product__c>(
      [
        SELECT Id, Name, Stock_Quantity__c
        FROM Inventory_Product__c
        WHERE Id IN :InventoryProductIds
      ]
    );

    system.debug(relatedInventoryProductMap);

    List<Inventory_Product__c> updateInventoryProducts = new List<Inventory_Product__c>();
    for (Order_Item__c orderItem : orderedItems) {
      Inventory_Product__c relatedInventory = relatedInventoryProductMap.get(
        orderItem.Inventory_Product__c
      );
      if (orderItem.Order_Quantity__c <= relatedInventory.Stock_Quantity__c) {
        relatedInventory.Stock_Quantity__c = relatedInventory.Stock_Quantity__c - orderItem.Order_Quantity__c;
        updateInventoryProducts.add(relatedInventory);
      }
    }

    update updateInventoryProducts;
  }

}
