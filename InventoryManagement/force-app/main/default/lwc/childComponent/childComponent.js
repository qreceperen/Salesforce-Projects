import { LightningElement, api } from 'lwc';

export default class ChildComponent extends LightningElement {
    // Receiving a property from parent
    @api message;

    customMessage = '';

    handleInputChange(event) {
        // Updating the custom message when the user types in the input field
        this.customMessage = event.target.value;
    }

    handleButtonClick() {
        // Dispatching a custom event to communicate with parent component
        const event = new CustomEvent('sendmessage', {
            detail: { childData: this.customMessage }
        });
        this.dispatchEvent(event);
    }
}