import { LightningElement, track, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';

export default class ContactViewer extends LightningElement {
    @track contacts = [];
    @track selectedContactId;
    @track selectedContact;

    // Fetch contacts from Apex
    @wire(getContacts)
    wiredContacts({ data, error }) {
        if (data) {
            this.contacts = data;
            console.log('Contact Records:', JSON.stringify(this.contacts, null, 2));
        } else if (error) {
            console.error('Error fetching contacts:', error);
        }
    }

    // Handle custom event from contact-picker-lwc
    handleContactSelected(event) {
        const selectedId = event.detail;
        console.log('Parent received selected contact ID:', selectedId);

        this.selectedContactId = selectedId;
        this.selectedContact = this.contacts.find(c => c.Id === selectedId) || null;

        console.log('Parent found full contact:', JSON.stringify(this.selectedContact, null, 2));
    }
}
