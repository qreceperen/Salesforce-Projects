import { LightningElement, api, wire, track } from "lwc";
import getAllContacts from "@salesforce/apex/ContactManagerController.getContactList";

export default class ContactManager extends LightningElement {
  @track contacts;
  @track columns = [
    { label: "First Name", fieldName: "FirstName" },
    { label: "Last Name", fieldName: "LastName" },
    { label: "Email", fieldName: "Email" },
    { label: "Account", fieldName: "AccountName", type: "text" }
  ];

  @wire(getAllContacts)
  wiredContacts({ error, data }) {
    if (data) {
      this.contacts = data.map((record) => {
        // Map the Account.Name to AccountName for each record
        return { ...record, AccountName: record.Account?.Name };
      });
    } else if (error) {
      console.log(error);
    }
  }
}
