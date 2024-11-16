public with sharing class orderItemHandler {

    public static void orderItemBeforeInsert(List<Order_Item__c> orderItems, Map<Id, Inventory_Product__c> InventoryProductMap ){
        for(Order_Item__c orderItem : orderItems){
            Inventory_Product__c relatedProduct = InventoryProductMap.get(orderItem.Inventory_Product__c);
            if(relatedProduct != null && orderItem.Order_Quantity__c > relatedProduct.Stock_Quantity__c){
                orderItem.addError('Not enough stock available for product: ' + relatedProduct.Name);
            }
        }
    }

    public static void orderItemAfterInsert(List<Order_Item__c> orderItems, Map<Id, Inventory_Product__c> InventoryProductMap){
        List<Inventory_Product__c> productsToUpdate = new List<Inventory_Product__c>();
        for(Order_Item__c orderItem : orderItems){
            Inventory_Product__c relatedProduct = InventoryProductMap.get(orderItem.Inventory_Product__c);
            if(relatedProduct != null){
                relatedProduct.Stock_Quantity__c = relatedProduct.Stock_Quantity__c - orderItem.Order_Quantity__c;
                productsToUpdate.add(relatedProduct);
            }
        }

        if(!productsToUpdate.isEmpty()){
            try{
                update productsToUpdate;
            }catch(DMLException e){
                system.debug(e.getMessage());
            }
        }
    }
}