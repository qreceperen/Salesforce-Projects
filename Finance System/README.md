📌 1. Objects & Fields
✅ 1. FinTrack_Invoice__c (Custom Object)
Purpose: Represents an invoice issued to a customer.

Field Name	Type	Description
Account__c	Lookup (Account)	Links to the customer/vendor.
Total_Amount__c	Currency	Total invoice amount.
Status__c	Picklist (Open, Partially Paid, Paid, Overdue)	Current invoice status.
✅ 2. FinTrack_Payment__c (Custom Object)
Purpose: Represents a payment made towards an invoice.

Field Name	Type	Description
Invoice__c	Master-Detail (FinTrack_Invoice__c)	Links payment to an invoice.
Amount_Paid__c	Currency	Amount paid by the customer.
Payment_Date__c	Date	Date when the payment was made.
Status__c	Picklist (Completed, Pending, Rejected)	Payment status.
✅ 3. Financial_Transaction__c (Custom Object)
Purpose: Represents a financial record for income or expenses.

Field Name	Type	Description
Account__c	Lookup (Account)	Links the transaction to a customer/vendor.
Amount__c	Currency	Transaction amount (Income or Expense).
Transaction_Type__c	Picklist (Income, Expense, Refund)	Defines the type of transaction.
Transaction_Date__c	Date	Date of the financial transaction.
FinTrack_Payment__c	Lookup (FinTrack_Payment__c)	Links to the payment (if applicable).
📌 2. Overall Summary of What We Achieved
🔹 Core Features Implemented
✅ 1. Payment Processing Logic

When a payment is made, we automatically create a Financial Transaction for it.
We ensure that Financial Transactions are linked to Payments and Invoices.
✅ 2. Overpayment Prevention

Payments cannot exceed the Invoice’s total amount.
We implemented validation logic that checks past payments and prevents overpayments using addError().
✅ 3. Trigger Handler Design Pattern

We refactored the trigger to use a separate handler class (PaymentTransactionHandler).
The handler:
Fetches Invoice details.
Fetches Total Paid Amount using Aggregate SOQL.
Validates payments before inserting transactions.
✅ 4. Bulk Processing & Performance Optimizations

Used Maps & Sets for faster lookups.
Used Aggregate SOQL to optimize total paid amount calculations.
Ensured bulk-safe operations to handle multiple payments at once.


-- BEFORE LWC PART SUM