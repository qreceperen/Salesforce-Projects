import { LightningElement, wire, track } from 'lwc';
import getAccountListWithOpportunities from '@salesforce/apex/AccountController.getAccountListWithOpportunities';

const COLUMNS = [
    { label: 'Account Name', fieldName: 'accountName' },
    { label: 'Industry', fieldName: 'industry' },
    { label: 'Number of Opportunities', fieldName: 'opportunityCount', type: 'button', 
        typeAttributes: { 
            label: { fieldName: 'opportunityCount' }, 
            name: 'show_opportunities', 
            variant: 'base' 
        } 
    }
];

export default class AccountTable extends LightningElement {
    columns = COLUMNS;
    @track accounts;
    @track isModalOpen = false;
    @track selectedOpportunities = [];

    @wire(getAccountListWithOpportunities)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data.map(accountWrapper => ({
                id: accountWrapper.account.Id,
                accountName: accountWrapper.account.Name,
                industry: accountWrapper.account.Industry,
                opportunityCount: accountWrapper.opportunityCount,
                opportunities: accountWrapper.account.Opportunities // Ensure this matches the correct case
            }));
            // console.log('Data retrieved: ' + JSON.stringify(this.accounts));
        } else if (error) {
            console.log('Error retrieving accounts: ', error);
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'show_opportunities') {
            this.selectedOpportunities = row.opportunities || []; // Ensure it's always an array
            this.showModal();
        }
    }

    showModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.selectedOpportunities = [];
    }
}
