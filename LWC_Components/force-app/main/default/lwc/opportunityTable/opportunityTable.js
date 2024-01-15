import { LightningElement, wire, track } from "lwc";
import getOpportunities from "@salesforce/apex/OpportunityController.getOpportunities";

const columns = [
    { label: 'Opportunity Name', fieldName: 'Name' },
    { label: 'Stage', fieldName: 'StageName' },
    { label: 'Close Date', fieldName: 'CloseDate', type:'date'},
    { label: 'Expected Amount', fieldName: 'ExpectedRevenue', type: 'currency' },
];

export default class OpportunityTable extends LightningElement {
  @track opportunities;
  columns = columns;

  @wire(getOpportunities)
  wiredOpportunities({ error, data }) {
    if (data) {
      this.opportunities = data;
      console.log("Received: ", data);
    } else if (error) {
      console.log(error);
    }
  }
}
