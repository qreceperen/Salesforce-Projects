import { LightningElement, track, wire } from "lwc";
import getTotalAccountsCount from "@salesforce/apex/accountController.getTotalAccountsCount";
import getAccountTypes from "@salesforce/apex/accountController.getAccountTypes";
import getAccountsByType from "@salesforce/apex/accountController.getAccountsByType";

export default class AccountTable extends LightningElement {
  @track currentPage = 1;
  @track pageSize = 3;
  @track totalRecords;
  @track totalPages;
  @track accountTypes;
  @track selectedType;
  @track accounts;

  columns = [
    { label: "Account Name", fieldName: "Name" },
    { label: "Account Type", fieldName: "Type" }
  ];

  //Query Accounts
  @wire(getAccountsByType, { accountType: "$selectedType", pageNumber:'$currentPage', pageSize:'$pageSize'})
  wiredAccounts({ error, data }) {
    if (data) {
      this.accounts = data;
    } else if (error) {
      console.log(error);
    }
  }

  //   Bring Type picklist
  @wire(getAccountTypes)
  wiredAccountTypes({ error, data }) {
    if (data) {
      this.accountTypes = data.map((type) => ({ label: type, value: type }));
    } else if (error) {
      console.error("Receiving Error-- " + JSON.stringify(error));
    }
  }

  @wire(getTotalAccountsCount, { accountType: "$selectedType" })
  wiredTotalAccountCount({ error, data }) {
    if (data) {
      this.totalRecords = data;
      this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    } else if (error) {
      console.log(error);
    }
  }

  handleTypeChange(event) {
    this.selectedType = event.detail.value;
  }

    // get isFirstPage() {
    //   return this.currentPage <= 1;
    // }

    // get isLastPage() {
    //   return this.currentPage >= this.totalPages;
    // }

    handleNextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
      }
    }

    handlePreviousPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
      }
    }
}
