trigger UpdateWonOpportunitiesCount on Opportunity(
  after insert,
  after update,
  after delete
) {
  //   Collect all AccountId when an opportunity is updated.
  if (Trigger.isInsert || Trigger.isUpdate) {
    UpdateWonOpportunitiesCountHandler.handleInsertUpdate(Trigger.new);
  }

  if (Trigger.isDelete) {
    UpdateWonOpportunitiesCountHandler.handleDelete(Trigger.old);
  }
}
