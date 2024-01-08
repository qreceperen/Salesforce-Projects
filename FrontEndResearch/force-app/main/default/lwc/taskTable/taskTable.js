import { LightningElement, track } from 'lwc';

export default class TaskTable extends LightningElement {

    // This array is intended to hold task data retrieved from the backend.
    // In this example, it's initialized with dummy data for demonstration purposes.

    /**Explanation of Each Field in the tasks Array
    id: A unique identifier for each task. It differentiates between tasks and is 
    typically the Salesforce record ID of the task.

    Subject: The name or title of the task. This is usually a descriptive label of the task, 
    like "Follow up call" or "Email client".
    dueDate: The date by which the task should be completed. It helps in tracking deadlines and 
    prioritizing tasks.

    status: The current status of the task, such as 'Open', 'Completed', or 'In Progress'. 
    This is important for understanding the progress of the task.

    @relatedAccount: The name of the account (either parent or child) that the task is related to. 
    This provides context as to which account the task is associated with.

    @whatId: The Salesforce record ID of the related account. Since the 
    WhatId field in the Task object is polymorphic, here it's filtered to only refer to account IDs. This is used to link to the account record in Salesforce. */

    @track tasks = [
        // 20 Dummy Records with clickable links for related accounts
        { id: 1, Subject: 'Task 1', dueDate: '2024-01-10', status: 'Open', relatedAccount: 'MollenbergChild1', whatId: '001xx000003DGEXAA4' },
        { id: 2, Subject: 'Task 2', dueDate: '2024-01-15', status: 'Completed', relatedAccount: 'MollenbergChild2', whatId: '001xx000003DGEYAA4' },
        { id: 3, Subject: 'Task 3', dueDate: '2024-01-20', status: 'In Progress', relatedAccount: 'MollenbergChild3', whatId: '001xx000003DGEXAA5' },
        { id: 4, Subject: 'Task 4', dueDate: '2024-01-25', status: 'Open', relatedAccount: 'MollenbergChild4', whatId: '001xx000003DGEYAA5' },
        { id: 5, Subject: 'Task 5', dueDate: '2024-01-30', status: 'Completed', relatedAccount: 'MollenbergChild5', whatId: '001xx000003DGEXAA6' },
        { id: 6, Subject: 'Task 6', dueDate: '2024-02-04', status: 'Open', relatedAccount: 'MollenbergChild6', whatId: '001xx000003DGEZAA4' },
        { id: 7, Subject: 'Task 7', dueDate: '2024-02-09', status: 'In Progress', relatedAccount: 'MollenbergChild7', whatId: '001xx000003DGFAAA4' },
        { id: 8, Subject: 'Task 8', dueDate: '2024-02-14', status: 'Completed', relatedAccount: 'MollenbergChild8', whatId: '001xx000003DGFBAA4' },
        { id: 9, Subject: 'Task 9', dueDate: '2024-02-19', status: 'Open', relatedAccount: 'MollenbergChild9', whatId: '001xx000003DGFCAA4' },
        { id: 10, Subject: 'Task 10', dueDate: '2024-02-24', status: 'In Progress', relatedAccount: 'MollenbergChild10', whatId: '001xx000003DGFDAA4' },
        { id: 11, Subject: 'Task 11', dueDate: '2024-02-28', status: 'Completed', relatedAccount: 'MollenbergChild1', whatId: '001xx000003DGEXAA4' },
        { id: 12, Subject: 'Task 12', dueDate: '2024-03-05', status: 'Open', relatedAccount: 'MollenbergChild2', whatId: '001xx000003DGEYAA4' },
        { id: 13, Subject: 'Task 13', dueDate: '2024-03-10', status: 'In Progress', relatedAccount: 'MollenbergChild3', whatId: '001xx000003DGEXAA5' },
        { id: 14, Subject: 'Task 14', dueDate: '2024-03-15', status: 'Completed', relatedAccount: 'MollenbergChild4', whatId: '001xx000003DGEYAA5' },
        { id: 15, Subject: 'Task 15', dueDate: '2024-03-20', status: 'Open', relatedAccount: 'MollenbergChild5', whatId: '001xx000003DGEXAA6' },
        { id: 16, Subject: 'Task 16', dueDate: '2024-03-25', status: 'In Progress', relatedAccount: 'MollenbergChild6', whatId: '001xx000003DGEZAA4' },
        { id: 17, Subject: 'Task 17', dueDate: '2024-03-30', status: 'Completed', relatedAccount: 'MollenbergChild7', whatId: '001xx000003DGFAAA4' },
        { id: 18, Subject: 'Task 18', dueDate: '2024-04-04', status: 'Open', relatedAccount: 'MollenbergChild8', whatId: '001xx000003DGFBAA4' },
        { id: 19, Subject: 'Task 19', dueDate: '2024-04-09', status: 'In Progress', relatedAccount: 'MollenbergChild9', whatId: '001xx000003DGFCAA4' },
        { id: 20, Subject: 'Task 20', dueDate: '2024-04-14', status: 'Completed', relatedAccount: 'MollenbergChild10', whatId: '001xx000003DGFDAA4' },
    ];

    columns = [
        { label: 'Subject', fieldName: 'Subject' },
        { label: 'Due Date', fieldName: 'dueDate', type: 'date' },
        { label: 'Status', fieldName: 'status' },
        {
            label: 'Related Account', 
            fieldName: 'whatId', 
            type: 'url',
            typeAttributes: { label: { fieldName: 'relatedAccount' }, target: '_blank' }
        },
        // Add more columns as needed
    ];

    // connectedCallback is a lifecycle hook that is called when the component is inserted into the DOM.
    // This method is used here to transform the whatId of each task into a clickable URL.
    // IMPORTANT: This functionality needs to be tested to ensure the URLs are correctly formed and navigable.
    connectedCallback() {
        this.tasks = this.tasks.map(task => {
            return {
                ...task,
                whatId: `/lightning/r/Account/${task.whatId}/view`
            };
        });
    }

    handleRowAction(event) {
        // Handle row actions like navigation to task details
    }
}
