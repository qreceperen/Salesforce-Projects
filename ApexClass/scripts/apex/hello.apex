Lead le;
le = [
  SELECT Id, Name, LeadSource, Industry, Company, NumberOfEmployees
  FROM Lead
  WHERE Name = 'Betty Bair'
  LIMIT 1
];

id leadId = le.id;
system.debug(le);
system.debug(leadId);

LeadConversationController.evaluateLeadRating(leadId);
