// This Script updates all Expense  Transaction Documents Name to `Income Transaction Name` 
// For example picture name 'testPic1', 'testPic2' to 'EX-000021-1','EX-000021-2'
// To update Income_Transaction__c you can change 'Expense_Transaction__c' in the script to 'Income_Transaction__c'

List<Expense_Transaction__c> incomeTransactions = [
    SELECT Id, Name FROM Expense_Transaction__c
];

Set<Id> transactionIds = new Set<Id>();
for(Expense_Transaction__c txn : incomeTransactions ){
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
for(Expense_Transaction__c txn : incomeTransactions){
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



