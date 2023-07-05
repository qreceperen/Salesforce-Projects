import { LightningElement, wire } from "lwc";
import { reduceErrors } from "c/ldsUtils";
import NAME_FIELD from "@salesforce/schema/Contact.FirstName";
import LNAME_FIELD from "@salesforce/schema/Contact.LastName";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import getContacts from "@salesforce/apex/ContactController.getContacts";
const COLUMNS = [
  { label: "Name", fieldName: NAME_FIELD.fieldApiName, type: "text" },
  {
    label: "Last Name",
    fieldName: LNAME_FIELD.fieldApiName,
    type: "text"
  },
  { label: "Email", fieldName: EMAIL_FIELD.fieldApiName, type: "text" }
];
export default class AccountList extends LightningElement {
  columns = COLUMNS;
  @wire(getContacts)
  contacts;
  get errors() {
    return this.contacts.error ? reduceErrors(this.contacts.error) : [];
  }
}
