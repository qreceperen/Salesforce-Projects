public class InventoryManager {
  public static void updateInventoryLevels(List<OrderItem> orderItems) {
    Set<Id> productIds = new Set<Id>();
    for (OrderItem orderItem : orderItems) {
      productIds.add(orderItem.Product2Id);
    }
    // Aggregate the quantity of Order Items by Product2 Id
    Map<Id, Decimal> productIdToQuantityMap = new Map<Id, Decimal>();
    for (OrderItem orderItem : orderItems) {
      if (productIdToQuantityMap.containsKey(orderItem.Product2Id)) {
        productIdToQuantityMap.put(
          orderItem.Product2Id,
          productIdToQuantityMap.get(orderItem.Product2Id) + orderItem.Quantity
        );
      } else {
        productIdToQuantityMap.put(orderItem.Product2Id, orderItem.Quantity);
      }
    }
    system.debug('productIdToQuantityMap--- ' + productIdToQuantityMap);

    // for (OrderItem oi : orderItems) {
    //   productIds.add(oi.Product2Id);
    //   productQuantities.put(oi.Product2Id, 0);
    // }

    // for (OrderItem oi : [
    //   SELECT Product2Id, SUM(Quantity) quantity
    //   FROM OrderItem
    //   WHERE Product2Id IN :productIds
    //   GROUP BY Product2Id
    // ]) {
    //   productQuantities.put(oi.Product2Id, oi.quantity);
    // }

    // List<Product2> productsToUpdate = new List<Product2>();
    // for (Id productId : productIds) {
    //   Product2 p = new Product2(Id = productId);
    //   p.Inventory_Level__c = productQuantities.get(p.Id);
    //   productsToUpdate.add(p);
    // }

    // update productsToUpdate;
  }
}
