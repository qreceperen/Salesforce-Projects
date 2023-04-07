public class Product2Helper {
  /**
   * @name COLLABORATION_GROUP
   * @description List of CollaborationGroup used in both business and test logic
   **/
  static List<CollaborationGroup> COLLABORATION_GROUP = [
    SELECT Id
    FROM CollaborationGroup
    WHERE Name = 'group name' OR Name = :('TEST' + 'group name')
    LIMIT 1
  ];

  /**
   * @name afterUpdate
   * @description called by product2 Trigger on After Update
   * @param List<Product2> newList
   * @param List<Product2> oldList
   **/
  public static void AfterUpdate(List<Product2> newList) {
    //ToDo: Declare a List of Product2 records named needsAnnouncement
    List<Product2> needsAnnouncement = new List<Product2>();

    //ToDo: Declare a Map of Strings to Inventory_Setting__mdt records
    Map<String, Decimal> invSettingMap = new Map<String, Decimal>();

    //ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
    List<Inventory_Setting__mdt> invSettings = [
      SELECT Id, DeveloperName, Low_Quantity_Alert__c
      FROM Inventory_Setting__mdt
    ];

    for (Inventory_Setting__mdt e : invSettings) {
      invSettingMap.put(e.DeveloperName, e.Low_Quantity_Alert__c);
    }

    for (Product2 c : newList) {
      if (
        invSettingMap.containsKey(c.Family) &&
        c.Quantity_Remaining__c < invSettingMap.get(c.Family)
      ) {
        needsAnnouncement.add(c);
      }
    }

    PostAlerts(needsAnnouncement);
  }

  /**
   * @name postAlerts
   * @description called by product2 Trigger on After Update
   * @param List<Product2> productList
   **/
  public static void PostAlerts(List<Product2> productList) {
    List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
    for (Product2 p : productList) {
      // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
      // expires in a day
      // does not notify users via email.
      // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
    }
    // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
  }
}
