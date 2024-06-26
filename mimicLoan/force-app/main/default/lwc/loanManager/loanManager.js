import { LightningElement, wire, track, api } from "lwc";
import getLoans from "@salesforce/apex/LoanController.getLoans";

export default class LoanManager extends LightningElement {
  @api recordId;
  @track loans;
  @track error;
  @track selectedLoan;
  @track isDetailedSectionOpen = false;

  columns = [
    { label: "Loan Name", fieldName: "Name", type: "text" },
    { label: "Loan Type", fieldName: "Loan_Type__c", type: "text" },
    { label: "Loan Amount", fieldName: "Loan_Amount__c", type: "currency" },
    { label: "Interest Rate", fieldName: "Interest_Rate__c", type: "percent" },
    { label: "Loan Term", fieldName: "Loan_Term__c", type: "number" },
    { label: "Status", fieldName: "Application_Status__c", type: "text" },
    {
      label: "Application Date",
      fieldName: "Application_Date__c",
      type: "date"
    },
    {
      type: "button",
      typeAttributes: { label: "Edit", name: "edit", title: "Edit" }
    }
  ];

  handleRowAction(event) {
    const action = event.detail.action;
    const row = event.detail.row;
    if(action.name === 'edit') {
        console.log('Selected Loan ID: ', row.Id);
    }
  }

  @wire(getLoans, { accountId: "$recordId" })
  wiredLoans(result) {
    if (result.data) {
      this.loans = result.data;
    } else if (result.error) {
      this.error = result.error;
    }
  }
}
