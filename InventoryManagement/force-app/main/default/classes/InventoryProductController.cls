
public with sharing class InventoryProductController {
    // Feed LWC to show all Inventory Products
    @AuraEnabled(cacheable=true)
    public static List<Inventory_Product__c> getInventoryProducts() {
        return [SELECT Id, Name, Stock_Quantity__c, Unit_Price__c FROM Inventory_Product__c];
    }


    @AuraEnabled
    public static void createOrderItem(Id productId, Integer orderQuantity) {

        if(productId == null || orderQuantity <= 0){
            throw new AuraHandledException('Product ID and order quantity are required and must be greater than 0.');
        }

        Order_Item__c orderItem = new Order_Item__c(
            Inventory_Product__c = productId,
            Order_Quantity__c = orderQuantity
        );

        insert orderItem;
    }

}