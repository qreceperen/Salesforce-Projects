import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SubmitFeedback extends LightningElement {
    @api recordId; // Automatically populated with the Event_Registration__c record ID

    handleSuccess() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Feedback submitted successfully!',
                variant: 'success',
            })
        );
        // this.resetForm();
    }

    handleError(event) {
        console.error('Error Details:', event.detail);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: event.detail || 'Error submitting feedback. Please try again.',
                variant: 'error',
            })
        );
    }
    

    handleRatingChange(event) {
        const rating = event.target.value;
        if (rating < 1 || rating > 10) {
            event.target.setCustomValidity('Rating must be between 1 and 10.');
        } else {
            event.target.setCustomValidity('');
        }
        event.target.reportValidity();
    }

    // resetForm() {
    //     // Reset the form after successful submission
    //     const form = this.template.querySelector('lightning-record-edit-form');
    //     if (form) {
    //         form.reset();
    //     }
    // }
}
