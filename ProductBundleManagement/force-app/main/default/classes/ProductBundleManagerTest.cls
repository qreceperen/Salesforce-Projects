@isTest
public with sharing class ProductBundleManagerTest {
  @isTest
  static void addSingleBundleWithProducts() {
    // Local Variables
    List<Id> returnedProductIds;
    String productBundleName;
    String ProductBundleDescription;
    List<Product_Bundle__c> insertedBundles;
    List<Bundle_Product_Link__c> linkedProducts;

    // Create Data
    productBundleName = 'Sample Bundle 1';
    ProductBundleDescription = 'This is description for Sample Bundle 1';
    returnedProductIds = TestDataFactory.productIds(5);

    // Execute Test
    Test.startTest();
    ProductBundleManager.createBundle(
      productBundleName,
      productBundleDescription,
      returnedProductIds
    );
    Test.stopTest();

    insertedBundles = [SELECT Id, Product_Name__c FROM Product_Bundle__c];

    // Assert
    Assert.areEqual(
      1,
      insertedBundles.size(),
      'Exactly one product bundle should be inserted.'
    );
    Assert.areEqual(
      productBundleName,
      insertedBundles[0].Product_Name__c,
      'Bundle Name is mismatched'
    );
    // Assert that the correct number of products are linked to the bundle
    linkedProducts = [
      SELECT Product__c
      FROM Bundle_Product_Link__c
      WHERE Product_Bundle__c = :insertedBundles[0].id
    ];
    Assert.areEqual(
      returnedProductIds.size(),
      linkedProducts.size(),
      'Incorrect number of product'
    );
  }
}
