import { LightningElement, wire } from "lwc";
import getAllProperties from "@salesforce/apex/PropertyServiceController.getAllProperties";

const COLUMNS = [
  { label: "Property Name", fieldName: "Name" },
  { label: "Code", fieldName: "Property_Code__c" },
  { label: "Status", fieldName: "Status__c" },
  { label: "Units", fieldName: "Total_Units__c", type: "number" },
  { label: "Address", fieldName: "Address__c" }
];
export default class PropertySummaryViewer extends LightningElement {
  allProperties = [];
  displayedProperties = [];
  error;
  columns = COLUMNS;

  pageSize = 5;
  currentPage = 1;
  totalPages = 0;

  @wire(getAllProperties)
  wiredProperties({ data, error }) {
    if (data) {
      this.allProperties = data;
      this.totalPages = Math.ceil(data.length / this.pageSize);
      this.updateDisplayedProperties();
    } else if (error) {
      this.error = error;
    }
  }

  updateDisplayedProperties() {
    const start = (this.currentPage - 1) * this.pageSize;
    const end = start + this.pageSize;
    this.displayedProperties = this.allProperties.slice(start, end);
  }

  handleNext() {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
      this.updateDisplayedProperties();
    }
  }
  handlePrevious() {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.updateDisplayedProperties();
    }
  }

  get isFirstPage(){
    return this.currentPage === 1;
  }

  get isLastPage(){
    return this.currentPage === this.totalPages;
  }
}
