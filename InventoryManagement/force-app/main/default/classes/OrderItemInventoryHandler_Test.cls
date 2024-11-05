@isTest
public with sharing class OrderItemInventoryHandler_Test {
  @TestSetup
  static void makeData() {
    Inventory_Product__c inventoryProduct = new Inventory_Product__c( Name = 'Laptop', Stock_Quantity__c = 10, Unit_Price__c = 1000);
    insert inventoryProduct;
  }

  @isTest
  public static void orderLessThanStockQuantity() {
    // Add Data
    Inventory_Product__c inventoryProduct = [ SELECT Id, Stock_Quantity__c FROM Inventory_Product__c WHERE Name = 'Laptop' LIMIT 1 ];
    Order_Item__c order = new Order_Item__c( Order_Quantity__c = 5, Inventory_Product__c = inventoryProduct.Id);
    //Execute Test
    Test.startTest();
    insert order;
    Test.stopTest();

    //Assert test
    inventoryProduct = [ SELECT Id, Stock_Quantity__c FROM Inventory_Product__c WHERE Name = 'Laptop' LIMIT 1 ];
    Assert.areEqual(5,inventoryProduct.Stock_Quantity__c, 'Expected stock quantity of Laptop to be 5 after ordering 5 units.');
  }
  @isTest
  public static void orderMoreThanStockQuantity() {
    // Add Data
    Inventory_Product__c inventoryProduct = [ SELECT Id, Stock_Quantity__c FROM Inventory_Product__c WHERE Name = 'Laptop' LIMIT 1 ];
    Order_Item__c order = new Order_Item__c( Order_Quantity__c = 11, Inventory_Product__c = inventoryProduct.Id);
    //Execute Test
    Test.startTest();
        try{
            insert order;
            System.assert(false, 'Expected an exception due to insufficient stock, but none was thrown');
        } catch(DMlException e){
            System.assert(e.getMessage().contains('Not Enough Stock to fullfill this request'),
                      'Unexpected error message: ' + e.getMessage());
        }
    Test.stopTest();

    }
}
