public with sharing class InventoryManager {
  public static void updateInventoryLevels(List<OrderItem> orderItems) {
    Set<Id> productIds = new Set<Id>();
    for (OrderItem orderItem : orderItems) {
      productIds.add(orderItem.Product2Id);
    }
    Map<Id, Decimal> productIdToQuantityMap = new Map<Id, Decimal>();
    for (AggregateResult result : [
      SELECT Product2Id, SUM(Quantity) quantity
      FROM OrderItem
      WHERE Product2Id IN :productIds
      GROUP BY Product2Id
    ]) {
      Id productId = (Id) result.get('Product2Id');
      Decimal quantity = (Decimal) result.get('quantity');
      productIdToQuantityMap.put(productId, quantity);
    }
    List<Product2> productsToUpdate = new List<Product2>();
    for (Id productId : productIds) {
      Product2 product = new Product2(Id = productId);
      Decimal currentInventoryLevel = product.Inventory_Level__c != null
        ? product.Inventory_Level__c
        : 0;
      Decimal orderItemQuantity = productIdToQuantityMap.get(productId) != null
        ? productIdToQuantityMap.get(productId)
        : 0;
      Decimal newInventoryLevel = currentInventoryLevel - orderItemQuantity;
      product.Inventory_Level__c = newInventoryLevel;
      productsToUpdate.add(product);
    }
    update productsToUpdate;
  }
}
