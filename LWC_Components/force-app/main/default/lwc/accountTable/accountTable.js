import { LightningElement, track, wire } from "lwc";
import getAccounts from "@salesforce/apex/accountController.getAccounts";
import getTotalAccountsCount from "@salesforce/apex/accountController.getTotalAccountsCount";

export default class AccountTable extends LightningElement {
    @track currentPage = 1;
    @track pageSize = 5;
    @track totalRecords;
    @track totalPages;
    accounts;

  columns = [
    { label: "Account Name", fieldName: "Name" },
    { label: "Account Type", fieldName: "Type" }
  ];

  @wire(getAccounts, {pageNumber:'$currentPage',pageSize:'$pageSize'})
  wiredAccounts({ error, data }) {
    if (data) {
      this.accounts = data;
    } else if (error) {
      console.log(error);
    }
  }

  @wire(getTotalAccountsCount)
  wiredTotalAccountCount({error,data}){
    if (data) {
        this.totalRecords = data;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        console.log("Retrieved data--" + this.totalRecords +'Page--'+this.totalPages );

    } else if(error){
        console.log(error);
    }
  }

  get isFirstPage(){
    return this.currentPage <=1;
  }

  get isLastPage() {
    return this.currentPage>=this.totalPages;
  }

  nextPage() {
    if(this.currentPage < this.totalPages) {
        this.currentPage++;
    }
  }

  previousPage() {
    if(this.currentPage>1) {
        this.currentPage--;
    }
  }
}
