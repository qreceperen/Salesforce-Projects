public with sharing class InventoryProductController {
    public static List<Inventory_Product__c> getInventoryProducts(){
        return [
            SELECT Id, Name, Stock_Quantity__c FROM Inventory_Product__c
        ];
    }
}