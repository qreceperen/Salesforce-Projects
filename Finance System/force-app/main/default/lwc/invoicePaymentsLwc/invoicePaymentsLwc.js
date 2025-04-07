import { LightningElement, api, wire, track } from 'lwc';
import getRelatedPaymentsWithInvoiceId from '@salesforce/apex/RefundProcessor.getRelatedPaymentsWithInvoiceId';
import processRefund from '@salesforce/apex/RefundProcessor.processRefund';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class InvoicePaymentsLwc extends LightningElement {
    @api recordId; // Holds the Invoice__c ID when placed on Invoice page
    @track payments = [];
    @track error;
    @track isModalOpen = false;
    @track selectedPaymentId;
    @track selectedPaymentAmount;
    @track refundAmount = 0;
    wiredPaymentsResult; // Store wire response for refreshApex

    // Define Table Columns
    columns = [
        { label: 'Payment Name', fieldName: 'Name', type: 'text' },
        { label: 'Amount Paid', fieldName: 'Amount_Paid__c', type: 'currency' },
        {
            type: 'button',
            label: 'Actions',
            initialWidth: 150,
            typeAttributes: {
                label: 'Request Refund',
                name: 'refund',
                title: 'Click to refund this payment',
                variant: 'brand',
            }
        }
    ];

    // Fetch related payments using @wire
    @wire(getRelatedPaymentsWithInvoiceId, { invoiceId: '$recordId' })
    wiredPayments(result) {
        this.wiredPaymentsResult = result; // Store wire result for refreshApex
        if (result.data) {
            this.payments = result.data;
            this.error = undefined;
            console.log('Payments:', JSON.stringify(this.payments));
        } else if (result.error) {
            this.error = result.error;
            this.payments = [];
        }
    }

    // Handle button click in the datatable
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'refund') {
            this.selectedPaymentId = row.Id;
            this.selectedPaymentAmount = row.Amount_Paid__c;
            this.refundAmount = 0;
            this.isModalOpen = true;
        }
    }

    // Handle refund amount change
    handleRefundAmountChange(event) {
        this.refundAmount = event.target.value;
        console.log('Refund Amount:', this.refundAmount);
    }

    // Close Modal
    closeModal() {
        this.isModalOpen = false;
    }

    // Call Apex method to process refund
    submitRefund() {
        if (!this.selectedPaymentId || this.refundAmount <= 0) {
            this.showToast('Error', 'Please enter a valid refund amount.', 'error');
            return;
        }

        processRefund({ paymentId: this.selectedPaymentId, refundAmount: parseFloat(this.refundAmount) })
            .then(result => {
                this.showToast('Success', result, 'success');
                this.isModalOpen = false;
                return refreshApex(this.wiredPaymentsResult); // Refresh payment data
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    // Helper function to show toast messages
    showToast(title, message, variant) {
        const event = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(event);
    }
}
