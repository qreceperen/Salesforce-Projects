List<Order> orderList = [
  SELECT
    Id,
    Account.Name,
    (SELECT Id, Quantity, PricebookEntry.Product2.Name FROM OrderItems)
  FROM Order
];

for (Order o : orderList) {
  system.debug('Account Name --- ' + o.Account.Name);
  for (OrderItem orderItem : o.OrderItems) {
    System.debug('OrderItem Id: ' + orderItem.Id);
    System.debug('OrderItem Quantity: ' + orderItem.Quantity);
    System.debug('Product Name: ' + orderItem.PricebookEntry.Product2.Name);
  }
}
