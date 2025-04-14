
import { LightningElement, api, wire, track } from 'lwc';
import getRelatedPaymentsWithInvoiceId from '@salesforce/apex/RefundProcessor.getRelatedPaymentsWithInvoiceId';
import processRefund from '@salesforce/apex/RefundProcessor.processRefund';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    {label: 'Payment Name', fieldName: 'Name', type: 'text'},
    {label: 'Amount Paid', fieldName:'Amount_Paid__c', type: 'currency'},
    {
        type: 'button',
        typeAttributes: {
            label: 'Request Refund',
            name: 'refund',
            title: 'Click to refund this payment',
            variant: 'brand'
        }
    }
];

export default class InvoicePaymentsLwc extends LightningElement {
    @api recordId;
    @track payments = [];
    @track error;
    columns = COLUMNS;
    @track isModalOpen = false;
    @track selectedPaymentId; // to track selected payment
    @track selectedPaymentAmount; // show how much was paid
    @track refundAmount = 0;  // user input for refund
    @track wiredPaymentResult;


    @wire(getRelatedPaymentsWithInvoiceId, { InvoiceId: '$recordId' })
    wiredPayments(result) {
        this.wiredPaymentResult = result; // Keep full result for refresh
        if (result.data) {
            this.payments = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.payments = [];
            this.error = result.error;
        }
 55    }    

    handleRowAction(event){
        const row = event.detail.row;
        if(event.detail.action.name === 'refund'){
            this.selectedPaymentId = row.Id;
            this.selectedPaymentAmount = row.Amount_Paid__c;
            this.refundAmount = 0;
            this.isModalOpen = true;
        }
  
    }

    submitRefund(){
        
        if(!this.selectedPaymentId || this.refundAmount <=0 ){
            console.log('Invalid Input. Cannot process');
            return;
        }
        processRefund({
            paymentId: this.selectedPaymentId,
            refundAmount: this.refundAmount
        })
        .then(result => {
            console.log('Apex Response:', result);
            this.isModalOpen = false;
            return refreshApex(this.wiredPaymentResult);
        })
        .catch(error => {
            console.log('Apex Error: ',error);
        })
    }

    closeModal(){
        this.isModalOpen = false;
    }

    handleRefundAmountChange(event){
        this.refundAmount = event.target.value;
        console.log('Refund Input Changed to: ', this.refundAmount);
    }

    connectedCallback(){
        console.log('recordId ', this.recordId);
    }
}
