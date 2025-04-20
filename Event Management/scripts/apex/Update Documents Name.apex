// This Script updates all Income Transaction Documents Name to `Income Transaction Name` 
// For example picture name 'testPic1', 'testPic2' to 'IN-000021-1','IN-000021-2'

List<Income_Transaction__c> incomeTransactions = [
    SELECT Id, Name FROM Income_Transaction__c
];

Set<Id> transactionIds = new Set<Id>();
for(Income_Transaction__c txn : incomeTransactions ){
    transactionIds.add(txn.id);
}

// Collect all Income Transaction Records with Document
List<ContentDocumentLink> links = [
    SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title
    FROM ContentDocumentLink
    WHERE LinkedEntityId IN :transactionIds
];

// All Income Transaction records is mapped within Id and Name
Map<Id, String> transactionNames = new Map<Id, String>();
for(Income_Transaction__c txn : incomeTransactions){
    transactionNames.put(txn.Id, txn.Name);
}

// We get only transaction with Document Attached
List<ContentDocument> docsToUpdate = new List<ContentDocument>();
Map<Id, Integer> counterPerRecord = new Map<Id,Integer>();

for(ContentDocumentLink cdl : links){
    Id txnId = cdl.LinkedEntityId;
    String baseName = transactionNames.get(txnId);
    
    // Get or start counter
    Integer counter = counterPerRecord.containsKey(txnId)
        ? counterPerRecord.get(txnId) + 1
        : 1;
    counterPerRecord.put(txnId, counter);

    // New title
    String newTitle = baseName + '-' + counter;

    // Debug preview
    System.debug('Old Title: ' + cdl.ContentDocument.Title);
    System.debug('Will be renamed to: ' + newTitle);

    // Prepare update
    ContentDocument doc = new ContentDocument(
        Id = cdl.ContentDocumentId,
        Title = newTitle
    );
    docsToUpdate.add(doc);
}

// ✅ Perform the actual update (optional, do when ready)
update docsToUpdate;



