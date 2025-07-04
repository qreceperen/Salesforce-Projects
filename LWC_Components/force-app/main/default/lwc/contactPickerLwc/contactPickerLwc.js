import { LightningElement, api } from 'lwc';

export default class ContactPickerLwc extends LightningElement {
    @api contacts = []; // parent provides it
    selectedId;

    get contactOptions(){
        return this.contacts.map(contact=>({
            label:contact.Name,
            value:contact.Id
        }))
    }
    handleChange(event){
        this.selectedId = event.detail.value;

        // Send Event to parent
        const contactEvent = new CustomEvent('contactselect',{
            detail: this.selectedId
        });
        this.dispatchEvent(contactEvent);
    }
}