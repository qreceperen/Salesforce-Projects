import { LightningElement, api, wire } from 'lwc';
import getEventFeedbackDetails from '@salesforce/apex/EventFeedbackWrapper.getEventFeedbackDetails';

export default class EventFeedbackDetails extends LightningElement {
    @api recordId; // Automatically provided by the record page
    eventFeedback; // Holds data fetched from Apex
    error; // Holds error, if any

    // Columns for lightning-datatable
    columns = [
        { label: 'Feedback Text', fieldName: 'Feedback_Text__c', type: 'text' },
        { label: 'Rating', fieldName: 'Rating__c', type: 'number' },
        { label: 'Submitted Date', fieldName: 'Submitted_Date__c', type: 'date' }
    ];

    // Wire Apex method to fetch data
    @wire(getEventFeedbackDetails, { eventCustomId: '$recordId' })
    wiredFeedback({ error, data }) {
        if (data) {
            this.eventFeedback = data; // Populate event feedback
            this.error = undefined; // Clear any previous errors
        } else if (error) {
            this.error = error; // Capture error
            this.eventFeedback = undefined; // Clear data if error occurs
            console.error('Error fetching Event Feedback Data: ', error);
        }
    }
}
