public with sharing class OrderItemInventoryHandler {
  //Shared Data when Trigger Worked
  private Map<Id, Inventory_Product__c> relatedInventoryProductMap;
  private List<Order_Item__c> orderItems;

  public OrderItemInventoryHandler(
    List<Order_Item__c> orderItems,
    Map<Id, Inventory_Product__c> relatedInventoryProductMap
  ) {
    this.orderItems = orderItems;
    this.relatedInventoryProductMap = relatedInventoryProductMap;
  }

  // Validate Inventory
  public void validateStockAvailability() {
    for (Order_Item__c orderItem : orderItems) {
      Inventory_Product__c inventoryProduct = relatedInventoryProductMap.get(
        orderItem.Inventory_Product__c
      );
      if (inventoryProduct.Stock_Quantity__c < orderItem.Order_Quantity__c) {
        orderItem.addError('Not Enough Stock to fullfill this request');
      }
    }
  }

  // Method to Update Inventory
  public void updateInventory() {
    List<Inventory_Product__c> updateInventoryProducts = new List<Inventory_Product__c>();
    for (Order_Item__c orderItem : orderItems) {
      Inventory_Product__c relatedInventory = relatedInventoryProductMap.get(
        orderItem.Inventory_Product__c
      );
      relatedInventory.Stock_Quantity__c =
        relatedInventory.Stock_Quantity__c - orderItem.Order_Quantity__c;
      updateInventoryProducts.add(relatedInventory);
    }

    update updateInventoryProducts;
  }
}
