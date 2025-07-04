import { LightningElement, api } from 'lwc';

export default class ContactDetailsLwc extends LightningElement {
    @api contact;
    renderedCallback(){
        console.log('Child received contact: ' + JSON.stringify(this.contact, null, 2));
    }
}