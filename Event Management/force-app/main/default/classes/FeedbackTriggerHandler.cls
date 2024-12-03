public with sharing class FeedbackTriggerHandler {
  public static void validateFeedback(List<Feedback__c> feedbacks) {
    // Step 1: Collect Related Event_Registration__c IDs
    Set<Id> eventRegistrationIds = new Set<Id>();
    for (Feedback__c feedback : feedbacks) {
      if (feedback.Event_Registration__c == null) {
        feedback.addError(
          'You cannot add a feedback without related Event Custom Record'
        );
      } else {
        eventRegistrationIds.add(feedback.Event_Registration__c);
      }
    }
    // Step 2: Query Related Event_Registration__c records
    Map<Id, Event_Registration__c> eventRegistrationMap = new Map<Id, Event_Registration__c>(
      [
        SELECT Id, Registration_Status__c
        FROM Event_Registration__c
        WHERE Id IN :eventRegistrationIds
      ]
    );

    // Step 3: Validate Feedback__c records
    for (Feedback__c feedback : feedbacks) {
      Event_Registration__c relatedRegistration = eventRegistrationMap.get(
        feedback.Event_Registration__c
      );
      if (
        relatedRegistration == null ||
        relatedRegistration.Registration_Status__c != 'Registered'
      ) {
        feedback.addError(
          'Feedback can only be submitted for registered attendees.'
        );
      }
    }
  }

  public static void updateAverageFeedbackScoreOnInsertAndUpdate(
    List<Feedback__c> feedbacks
  ) {
    // Step 1: Collect Related Event_Registration__c IDs
    Set<Id> eventRegistrationIds = new Set<Id>();
    for (Feedback__c feedback : feedbacks) {
      if (feedback.Event_Registration__c != null) {
        // Defensive check for null Event_Registration__c
        eventRegistrationIds.add(feedback.Event_Registration__c);
      }
    }
    if (eventRegistrationIds.isEmpty()) {
      // Defensive check: Skip if no Event_Registration__c IDs are found
      System.debug(
        'No Event_Registration__c records found. Skipping further processing.'
      );
      return;
    }

    // Step 2: Query Event_Registration__c for Related Event_Custom__c
    List<Event_Registration__c> relatedEventRegistration = [
      SELECT Id, Event_Custom__c
      FROM Event_Registration__c
      WHERE Id IN :eventRegistrationIds
    ];

    Set<Id> eventCustomIds = new Set<Id>();
    for (Event_Registration__c eventReg : relatedEventRegistration) {
      if (eventReg.Event_Custom__c != null) {
        // Defensive check for null Event_Custom__c
        eventCustomIds.add(eventReg.Event_Custom__c);
      }
    }
    if (eventCustomIds.isEmpty()) {
      // Defensive check: Skip if no Event_Custom__c IDs are found
      System.debug(
        'No Event_Custom__c records found. Skipping further processing.'
      );
      return;
    }

    // Step 3: Query All Related Feedbacks for Event_Custom__c and Take Aggregate Result
    List<AggregateResult> relatedFeedbackToEventCustom = [
      SELECT
        Event_Registration__r.Event_Custom__c eventCustomId,
        AVG(Rating__c) averageRating
      FROM Feedback__c
      WHERE Event_Registration__r.Event_Custom__c IN :eventCustomIds
      GROUP BY Event_Registration__r.Event_Custom__c
    ];
    if (relatedFeedbackToEventCustom.isEmpty()) {
      // Defensive check: Skip if no feedback records are found
      System.debug(
        'No feedback records found for the given Event_Custom__c IDs. Skipping further processing.'
      );
      return;
    }

    // Step 4: Map the Results for Easy Updates
    Map<Id, Decimal> ratingsMap = new Map<Id, Decimal>();
    for (AggregateResult aggRes : relatedFeedbackToEventCustom) {
      Id eventCustomId = (Id) aggRes.get('eventCustomId');
      Decimal averageRating = (Decimal) aggRes.get('averageRating');
      ratingsMap.put(eventCustomId, averageRating);
    }

    // Step 5: Query Event_Custom__c to Update Average Feedback Score
    List<Event_Custom__c> eventCustomsToUpdate = [
      SELECT Id, Average_Feedback_Score__c
      FROM Event_Custom__c
      WHERE Id IN :ratingsMap.keySet()
    ];
    if (eventCustomsToUpdate.isEmpty()) {
      // Defensive check: Skip if no Event_Custom__c records are found
      System.debug(
        'No Event_Custom__c records found for update. Skipping further processing.'
      );
      return;
    }

    for (Event_Custom__c eventcustom : eventCustomsToUpdate) {
      eventcustom.Average_Feedback_Score__c = ratingsMap.get(eventcustom.Id);
    }

    // Step 6: Perform Bulk Update
    update eventCustomsToUpdate;
  }
}
