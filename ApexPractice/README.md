# Salesforce Apex Trigger Logic Summary

## Overview

This document outlines the logic for the **`AccountTrigger.trigger`** in a Salesforce project, focusing on manipulating a custom checkbox field based on the Account's name.

## Logic

- **Positive Condition**: If an Account's `Name` is "Perform Apex Test Checkbox Test", set `Account.Test_Checkbox__c` to `true`.
- **Negative Condition**: If an Account's `Name` is not "Perform Apex Test Checkbox Test", set `Account.Test_Checkbox__c` to `false`.

The trigger should efficiently handle both individual and bulk operations, maintaining performance and adhering to Salesforce governor limits. Testing is crucial to ensure the functionality and performance of the trigger, with a focus on achieving 100% code coverage.

# Salesforce Apex Project Plan

## 1. Data Model and Setup

- **Add Checkbox Field**: Create a new checkbox field `Account.Test_Checkbox__c` in the Account SObject.
- **Update Page Layout**: Ensure the new checkbox field is visible on the standard Account page layout.
- **Use Scratch Org**: Perform all developments in a fresh scratch org, not in an M&T Sandbox.

## 2. Utilizing DMLUtils Package

- **Install DMLUtils**: If possible, install and use the DMLUtils package in your scratch org.

## 3. Development Approach

- **Test-Driven Development (TDD)**: Write tests first, ensuring they fail initially, before writing logic.
- **Behavior-Driven Development (BDD)**: Focus on the behavior of the software during testing.

## 4. Test Data Factory (AccountTriggerFactory.cls)

- **No DML Operations**: The factory class should not perform DML operations.
- **Return SObject Instances**: Capable of returning both individual and collection instances of SObjects.
- **Use @IsTest Annotation**: Annotate with `@IsTest` to exclude from org’s code coverage.
- **Public Methods**: Methods returning values to other classes must be public.

## 5. Test Class (AccountTestCheckboxTest.cls)

- **Test Scenarios**:
  - _Positive Test_: Verify `Account.Test_Checkbox__c = true` when `Account.Name` is 'Perform Apex Test Checkbox Test'.
  - _Negative Test_: Verify `Account.Test_Checkbox__c = false` when `Account.Name` is not 'Perform Apex Test Checkbox Test'.
  - _Positive Bulk Test_: Validate the positive condition with 200 Account instances.
  - _Negative Bulk Test_: Validate the negative condition with 200 Account instances.

## 6. Core Logic Class (AccountTestCheckbox.cls)

- **Handle Account Collections**: Accept and process a collection of Account instances.
- **Encapsulation and Methods**: Use a private `List<Account>` instance variable and public methods.
- **Perform DML**: Preferably use DMLUtils for DML operations; include error handling with try/catch and `System.debug()` for logging exceptions.

## 7. Apex Trigger (AccountTrigger.trigger)

- **Trigger as a Router**: No direct logic in the trigger; it should act as a router to core logic classes.
- **Conditional Logic**: Implement conditions such as `trigger.isBefore`, `trigger.isAfter`, etc.
- **One-Line Calls to Core Logic**: Use concise calls to the core logic class's methods.

## 8. Comprehensive Testing and Validation

- **Pass All Test Methods**: Ensure all methods in `AccountTestCheckboxTest.cls` pass.
- **100% Code Coverage**: Achieve total code coverage in the local scratch org.
- **Functional Tests**: Perform functional testing on Account records, including importing 200 records.

## 9. Advanced Challenge - Custom Metadata

- **Create Custom Metadata**: Includes a checkbox for disabling all triggers.
- **Modify Triggers and Tests**: Adjust your trigger and test classes to respect the Custom Metadata settings.
- **Additional Testing**: Perform tests with Custom Metadata enabled and disabled, ensuring all test cases pass and maintain 100% code coverage.
