import { LightningElement, wire, track } from 'lwc';
import getCases from '@salesforce/apex/CaseController.getCases';
import updateCaseStatus from '@salesforce/apex/CaseController.updateCaseStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseList extends LightningElement {
    @track searchTerm = '';
    @track cases = [];
    @track columns = [
        { label: 'Case Number', fieldName: 'CaseNumber', type: 'text' },
        { label: 'Subject', fieldName: 'Subject', type: 'text' },
        { label: 'Status', fieldName: 'Status', type: 'text', editable: true },
        { label: 'Priority', fieldName: 'Priority', type: 'text' },
        { label: 'Owner', fieldName: 'OwnerName', type: 'text' }
    ];

    @wire(getCases, {searchTerm:'$searchTerm'})
    wiredCases({error,data}) {
        if (data) {
            this.cases = data.map(caseRecord => {
                let caseCopy = Object.assign({}, caseRecord);
                caseCopy.OwnerName = caseRecord.Owner.Name;
                return caseCopy;
            });
        } else if (error) {
            console.error('Error:', error);
            this.cases = undefined;
        }
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;

    }

    handleSave(event) {
        const updatedFields = event.detail.draftValues;
        console.log(updatedFields);

        // Process each edited row
        const promises = updatedFields.map((row) => {
            const {Id, Status} = row;
            return updateCaseStatus({caseId:Id, newStatus:Status});
        });

        Promise.all(promises)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title:'Success',
                    message:'Case(s) updated',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    titles:'Error updating record',
                    message:error.body.message,
                    variand:'error'
                })
            );
        });
    }
}
