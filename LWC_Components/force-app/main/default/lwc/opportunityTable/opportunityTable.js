import { LightningElement, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';
import getTotalOpportunitiesCount from '@salesforce/apex/OpportunityController.getTotalOpportunitiesCount';

export default class OpportunityTable extends LightningElement {
    @track currentPage = 1;
    @track pageSize = 5;
    @track totalRecords;
    @track totalPages;
    opportunities;

    columns = [
        { label: 'Opportunity Name', fieldName: 'Name' },
        { label: 'Stage', fieldName: 'StageName' },
        { label: 'Close Date', fieldName: 'CloseDate', type: 'date' },
        { label: 'Expected Amount', fieldName: 'ExpectedRevenue', type: 'currency' }
    ];

    @wire(getOpportunities, { pageNumber: '$currentPage', pageSize: '$pageSize' })
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunities = data;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getTotalOpportunitiesCount)
    wiredTotalCount({ error, data }) {
        if (data) {
            this.totalRecords = data;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        } else if (error) {
            console.error(error);
        }
    }

    get isFirstPage() {
        return this.currentPage <= 1;
    }

    get isLastPage() {
        return this.currentPage >= this.totalPages;
    }

    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }
}
