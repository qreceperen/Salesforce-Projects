import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError } from 'lightning/empApi'; // This is critical!

export default class DisconnectionNotice extends LightningElement {
    subscription = {};
    status;
    identifier;
    channelName = '/event/Asset_Disconnection__e';

    connectedCallback() {
        this.handleSubscribe();
    }

    messageCallback = (response) => {
        const payload = response.data.payload;
        this.status = payload.Disconnected__c;
        this.identifier = payload.Asset_Identifier__c;

        if (this.status) {
            this.showSuccessToast(this.identifier);
        } else {
            this.showErrorToast();
        }
    };

    handleSubscribe() {
        subscribe(this.channelName, -1, this.messageCallback).then(response => {
            this.subscription = response;
        });

        onError(error => {
            console.error('EMP API error:', JSON.stringify(error));
        });
    }

    disconnectedCallback() {
        // Optional: clean up subscription when component is removed
        // unsubscribe(this.subscription, response => {
        //     console.log('Unsubscribed', response);
        // });
    }

    showSuccessToast(assetId) {
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Asset Id ' + assetId + ' is now disconnected',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    showErrorToast() {
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Asset was not disconnected. Try Again.',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}
