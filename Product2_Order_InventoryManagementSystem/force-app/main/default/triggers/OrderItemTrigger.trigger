trigger OrderItemTrigger on OrderItem(
  after insert,
  after update,
  after delete
) {
  if (
    Trigger.isAfter &&
    (Trigger.isInsert ||
    Trigger.isUpdate ||
    Trigger.isDelete)
  ) {
    InventoryManager.updateInventoryLevels(Trigger.new);
  }
}
