import { LightningElement, wire, track } from 'lwc';
import getUserPermissionSets from '@salesforce/apex/UserPermissionSetController.getUserPermissionSets';

export default class UserPermissionSets extends LightningElement {
    @track permissionSetAssignments;
    @track error;
    searchKey = '';

    columns = [
        { label: 'User Name', fieldName: 'AssigneeName', type: 'text' },
        {
            label: 'Permission Set Name',
            fieldName: 'PermissionSetName',
            type: 'text'
        }
    ];

    @wire(getUserPermissionSets, { searchKey: '$searchKey' })
    wiredPermissionSets({ error, data }) {
        if (data) {
            console.log('Data Returned:' + JSON.stringify(data, null, 2));
            this.permissionSetAssignments = data.map((record) => {
                return {
                    Id: record.Id,
                    AssigneeName: record.Assignee.Name,
                    PermissionSetName: record.PermissionSet.Name
                };
            });
            this.error = undefined;
        } else if (error) {
            // Use JSON.stringify to convert the error object to a string
            this.error = JSON.stringify(error, null, 2); // The '2' argument here adds indentation for readability
            console.log('Error:', this.error);
            this.permissionSetAssignments = undefined;
        }
    }

    handleSearch(event) {
        console.log(event.target.value);
        // window.clearTimeout(this.delayTimeout);
        this.searchKey = event.target.value;
        // this.delayTimeout = setTimeout(() => {
        //     this.searchKey = searchKey;
        // }, 300);
    }
}
