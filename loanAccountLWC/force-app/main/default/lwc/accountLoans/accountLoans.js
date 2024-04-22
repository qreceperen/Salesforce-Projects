import { LightningElement, api, wire, track } from "lwc";
import getLoans from "@salesforce/apex/LoanController.getLoans";
import getLoanById from "@salesforce/apex/LoanController.getLoanById";

export default class AccountLoans extends LightningElement {
  @api recordId;
  @track loans;
  isEditMode = false;

  columns = [
    { label: "Loan Type", fieldName: "Loan_Type__c", type: "text" },
    { label: "Loan Amount", fieldName: "Loan_Amount__c", type: "currency" },
    { label: "Interest Rate", fieldName: "Interest_Rate__c", type: "percent" },
    { label: "Loan Term", fieldName: "Loan_Term__c", type: "number" },
    { label: "Status", fieldName: "Application_Status__c", type: "text" },
    { label: "Application Date", fieldName: "Application_Date__c", type: "date"},
    {
      type: "button",
      typeAttributes: {
        label: "Edit",
        name: "edit",
        title: "Edit",
        disabled: false,
        value: "edit",
        iconPosition: "left"
      }
    }
  ];

  @wire(getLoans, { accountId: "$recordId" })
  wiredLoans({ error, data }) {
    if (data) {
      this.loans = data;
    } else if (error) {
      this.loans = undefined;
      console.error("Error:", error);
    }
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    if (actionName === 'edit') {
        this.fetchLoan(row.id);
    }
  }

  fetchLoan(loanId) {
    getLoanById({loanId})
        .then(result => {
            this.editRecord = result;
            this.isEditMode = true;
        })
        .catch(error => {
            console.error('Error Fetching Loan', error);
            this.editRecord = {};
        });
  }

  cancelEdit() {
    this.isEditMode = false;
  }
}
