@isTest
public with sharing class ProductBundleManagerTest {
  @isTest
  static void addSingleBundleWithProducts() {
    // Local Variables
    List<Id> returnedProductIds;
    String productBundleName;
    String ProductBundleDescription;
    List<Product_Bundle__c> insertedBundles;

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

    insertedBundles = [SELECT Id FROM Product_Bundle__c];

    // Assert
    Assert.areEqual(
      1,
      insertedBundles.size(),
      'Exactly one product bundle should be inserted.'
    );
  }
}
