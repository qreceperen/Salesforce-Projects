import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountContactController.getAccounts';

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    {
        label: 'Number of Contacts',
        fieldName: 'contactCount',
        type: 'button',
        typeAttributes: {
            label: {
                fieldName: 'contactCount'
            },
            name: 'viewContacts',
            variant: 'base',
            tooltip: 'Click to view contacts'
        }
    }
];

export default class AccountContactTable extends LightningElement {
    @track accounts;
    @track error;
    @track isModalOpen = false;
    @track selectedContacts = [];
    columns = columns;

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            console.log('Retrieve Data: ', JSON.stringify(data));
            // Transform the data to match the structure expected by lightning-datatable
            this.accounts = data.map(accountWrapper => ({
                Id: accountWrapper.account.Id,
                Name: accountWrapper.account.Name,
                Industry: accountWrapper.account.Industry,
                Phone: accountWrapper.account.Phone,
                contactCount: accountWrapper.contactCount.toString(), // URL fields expect strings
                Contacts: accountWrapper.account.Contacts // Add Contacts to the data
            }));
            this.error = undefined;
            console.log('Received Accounts: ', JSON.stringify(this.accounts));
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }

    handleRowAction(event) {
        if (event.detail.action.name === 'viewContacts') {
            const row = event.detail.row;
            this.selectedContacts = row.Contacts;
            this.isModalOpen = true;
        }
    }

    closeModal() {
        this.isModalOpen = false;
        this.selectedContacts = [];
    }
}
