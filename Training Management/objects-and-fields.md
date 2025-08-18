# Training Management System - Objects and Fields

## Custom Objects Overview

This Salesforce Training Management System consists of 3 custom objects that manage the complete training lifecycle:

1. **Training_Course__c** - Course catalog with scheduling and capacity
2. **Training_Enrollment__c** - Junction connecting customers to courses with progress tracking  
3. **Training_Certificate__c** - Certificates issued upon course completion

---

## Training_Course__c

| Field Name | Field Type | Description | Picklist Values |
|------------|------------|-------------|-----------------|
| Category__c | Picklist | Course category classification | Technical, Leadership, Compliance, Safety |
| Description__c | LongTextArea | Detailed course description | N/A |
| Duration_Hours__c | Number | Course duration in hours | N/A |
| End_Date__c | Date | Course end date | N/A |
| Instructor__c | Text | Instructor name | N/A |
| Max_Capacity__c | Number | Maximum student capacity | N/A |
| Start_Date__c | Date | Course start date | N/A |
| Status__c | Picklist | Course availability status | Active, Inactive, Draft |

---

## Training_Enrollment__c

| Field Name | Field Type | Description | Picklist Values |
|------------|------------|-------------|-----------------|
| Comments__c | Html | Rich text comments/notes | N/A |
| Completion_Date__c | Date | Date when course was completed | N/A |
| Customer__c | Lookup (Contact) | Reference to enrolled customer | N/A |
| Enrollment_Date__c | Date | Date of enrollment | N/A |
| Grade__c | Picklist | Final grade received | A, B, C, D, F |
| Progress_Percentage__c | Percent | Course completion percentage | N/A |
| Status__c | Picklist | Enrollment status | Enrolled, In Progress, Completed, Cancelled |
| Training_Course__c | Lookup (Training_Course__c) | Reference to the training course | N/A |

---

## Training_Certificate__c

| Field Name | Field Type | Description | Picklist Values |
|------------|------------|-------------|-----------------|
| Certificate_Number__c | Text | Unique certificate identifier | N/A |
| Customer__c | Lookup (Contact) | Reference to certificate recipient | N/A |
| Expiry_Date__c | Date | Certificate expiration date | N/A |
| Issue_Date__c | Date | Date certificate was issued | N/A |
| PDF_Attachment__c | Url | URL to certificate PDF document | N/A |
| Status__c | Picklist | Certificate validity status | Valid, Expired, Revoked |
| Training_Course__c | Lookup (Training_Course__c) | Reference to completed course | N/A |

---

## Object Relationships

### Data Model Flow:
1. **Training_Course__c** ← **Training_Enrollment__c** ← **Contact** (Customer)
2. **Training_Course__c** ← **Training_Certificate__c** ← **Contact** (Customer)

### Key Relationships:
- **Training_Enrollment__c** serves as a junction object between Training_Course__c and Contact
- **Training_Certificate__c** links completed courses to customers
- Both enrollment and certificate objects reference the standard Contact object for customer management

### Field Type Summary:
- **Date fields**: 7 total (managing course schedules and completion tracking)
- **Picklist fields**: 5 total (status management and categorization)
- **Lookup relationships**: 4 total (connecting objects in the data model)
- **Text/Number fields**: 6 total (basic data capture)
- **Special types**: Percent (progress), Html (rich comments), Url (PDF links), LongTextArea (descriptions)