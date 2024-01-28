import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';

export default class ContactListFilter extends LightningElement {
    @track filter = '';
    @track contacts;
    @track error;

    pageSize = 10; // Number of contacts per page
    currentPage = 1; // Current active page
    totalContacts = 0; // Total number of contacts
    totalPages = 0; // Total numner of pages
    paginatedContacts = []; // Contacts to display on current page

    handleFilterChange(event) {
        this.filter = event.target.value;
    }

    handleSearch() {
        getContacts({filter:this.filter})
            .then(result =>{
                this.contacts = result;
                this.totalContacts = result.lenght;
                this.totalPages = Math.ceil(this.totalContacts / this.pageSize);
                this.currentPage = 1;
                this.setPaginatedContacts();
                this.error = undefined;
        })
            .catch(error =>{
                this.error = error;
                this.contacts = undefined;
        })

    }

    setPaginatedContacts() {
        const startIndex = (this.currentPage -1) * this.pageSize;
        const endIndex = this.currentPage * this.pageSize;
        this.paginatedContacts = this.contacts.slice(startIndex, endIndex);
    
    }

}