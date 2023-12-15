public with sharing class TestDataFactory {
  // Create products
  public static List<Id> productIds(Integer numberOfProducts) {
    // Local Variable
    List<Id> productIds;
    Map<id, Product2> productMap;
    List<Product2> productList = new List<Product2>();
    for (Integer i = 0; i < numberOfProducts; i++) {
      Product2 product = new Product2(Name = 'Product' + i, IsActive = true);
      productList.add(product);
    }
    insert productList;

    // Extract the IDs from the productList
    productMap = new Map<Id, Product2>(productList);
    productIds = new List<Id>(productMap.keySet());
    return productIds;
  }
}
