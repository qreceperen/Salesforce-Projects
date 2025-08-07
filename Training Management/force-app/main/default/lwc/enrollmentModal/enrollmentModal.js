import { LightningElement, api } from 'lwc';

export default class EnrollmentModal extends LightningElement {
    @api visible = false;
    @api courseId;
    customerId;

    handleCustomerSelect(event) {
        this.customerId = event.detail.recordId;
    }

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleConfirm() {
        if (this.customerId && this.courseId) {
            this.dispatchEvent(new CustomEvent('enroll', {
                detail: {
                    customerId: this.customerId,
                    courseId: this.courseId
                }
            }));
        }
    }
}