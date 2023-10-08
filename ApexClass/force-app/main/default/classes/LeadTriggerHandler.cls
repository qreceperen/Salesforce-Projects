public class LeadTriggerHandler {
  public void handle(List<Lead> leads) {
    for (Lead lead : leads) {
      String rating = LeadConversationController.evaluateLeadRating(lead.Id);
      LeadConversationController.convertedLead(lead.Id, rating);
    }
  }
}
