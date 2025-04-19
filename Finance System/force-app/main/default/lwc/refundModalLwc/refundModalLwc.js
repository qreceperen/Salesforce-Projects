import { LightningElement, api, track } from 'lwc';

export default class RefundModalLwc extends LightningElement {
    @api selectedAmountFromParent; // This will come from parent.
    @track refundAmount = 0;

    handleRefundAmountChange(event){
        this.refundAmount = event.target.value;
    }

    handleSubmit(){
        const refundEvent = new CustomEvent('refundsubmit', {
            detail: {
                refundAmount: parseFloat(this.refundAmount)
            }
        });
        this.dispatchEvent(refundEvent);
    }

    handleCancel(){
        this.dispatchEvent(new CustomEvent('close'));
    }

}