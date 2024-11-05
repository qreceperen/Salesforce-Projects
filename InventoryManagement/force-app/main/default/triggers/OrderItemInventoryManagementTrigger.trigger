trigger OrderItemInventoryManagementTrigger on Order_Item__c(
  before insert,
  after insert
) {
  List<Order_Item__c> orderItems = Trigger.New;
  //Collect Inventory ProductsIds
  Set<Id> InventoryProductIds = new Set<Id>();
  for (Order_Item__c orderitem : orderItems) {
    InventoryProductIds.add(orderitem.Inventory_Product__c);
  }

  // Query Related Inventory Products Once
  Map<Id, Inventory_Product__c> relatedInventoryProductMap = new Map<Id, Inventory_Product__c>(
    [
      SELECT Id, Name, Stock_Quantity__c
      FROM Inventory_Product__c
      WHERE Id IN :InventoryProductIds
    ]
  );

  OrderItemInventoryHandler handler = new OrderItemInventoryHandler    (
    Trigger.New,
    relatedInventoryProductMap
  );

  // Before Trigger Prevent any Order Item Insertion if there is no enough inventory
  if (Trigger.isBefore && Trigger.isInsert) {
    // Validate Stock
    handler.validateStockAvailability();
  }

  // After Insert
  if (Trigger.isAfter && Trigger.isInsert) {
    handler.updateInventory();
  }

}
