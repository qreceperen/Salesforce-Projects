import { LightningElement, track, wire } from "lwc";
import getAccounts from "@salesforce/apex/accountController.getAccounts";

export default class AccountTable extends LightningElement {
  accounts;

  columns = [
    { label: "Account Name", fieldName: "Name" },
    { label: "Account Type", fieldName: "Type" }
  ];

  @wire(getAccounts)
  wiredAccounts({ error, data }) {
    if (data) {
      this.accounts = data;
    } else if (error) {
      console.log(error);
    }
  }
}
