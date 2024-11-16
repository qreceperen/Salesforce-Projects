import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    parentMessage = 'Hello from Parent!';
    messageFromChild = '';

    handleChildMessage(event) {
        // Receiving data from child component
        this.messageFromChild = event.detail.childData;
    }
}