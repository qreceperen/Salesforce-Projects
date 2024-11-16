trigger orderItemTrigger on Order_Item__c (before insert, after insert) {
    Set<Id> InventoryProductIds = new Set<Id>();

    for(Order_Item__c orderItem : Trigger.New){
        InventoryProductIds.add(orderItem.Inventory_Product__c);
    }
    
    Map<Id, Inventory_Product__c> InventoryProductMap = new Map<Id, Inventory_Product__c>([
        SELECT Id, Stock_Quantity__c, Name
        FROM Inventory_Product__c
        WHERE Id IN :InventoryProductIds
    ]);

    // Start with before insert: Prevent creation if Stock Quantity is less than Order Quantity.
    if(Trigger.isBefore && Trigger.isInsert){
        orderItemHandler.orderItemBeforeInsert(Trigger.New, InventoryProductMap);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        orderItemHandler.orderItemAfterInsert(Trigger.New, InventoryProductMap);
    }
}
