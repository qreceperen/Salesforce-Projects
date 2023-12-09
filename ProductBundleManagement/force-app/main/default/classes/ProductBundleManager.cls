public with sharing class ProductBundleManager {
  // Creates a new product bundle and associates products to it.
  public static void createBundle(
    String productBundleName,
    String productBundleDescription,
    List<Id> productIds
  ) {
    // List<ProductBundle__c> productBundleList;
    // Local Variables
    Product_Bundle__c newProductBundle;
    Id bundleId;

    // Insert Product Bundle
    newProductBundle = new Product_Bundle__c();
    newProductBundle.Product_Name__c = productBundleName;
    newProductBundle.Description__c = productBundleDescription;
    try {
      insert newProductBundle;
    } catch (Exception e) {
      system.debug('ERROR Inserting new Product' + e.getMessage());
    }

    bundleId = newProductBundle.id;
    associateProductWithBundle(bundleId, productIds);
  }
  // Associates a list of products with a specific bundle.
  static void associateProductWithBundle(Id bundleId, List<Id> productIds) {
    // Local Variables
    List<Bundle_Product_Link__c> bundleProductList;
    Bundle_Product_Link__c singleBundleProduct;

    // Preparing a list of Bundle_Product_Link__c records to link each product to the bundle
    bundleProductList = new List<Bundle_Product_Link__c>();
    for (Id productId : productIds) {
      singleBundleProduct = new Bundle_Product_Link__c();
      singleBundleProduct.Product_Bundle__c = bundleId;
      singleBundleProduct.Product__c = productId;
      bundleProductList.add(singleBundleProduct);
    }

    try {
      insert bundleProductList;
    } catch (Exception e) {
      system.debug('ERROR Inserting bundle' + e.getMessage());
    }
  }

  public static void listBundles() {
  }
}
