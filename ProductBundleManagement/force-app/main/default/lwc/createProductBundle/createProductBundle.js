import { LightningElement, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getAvailableProducts from "@salesforce/apex/ProductBundleManager.getAvailableProducts";
import createBundle from "@salesforce/apex/ProductBundleManager.createBundle";

export default class CreateProductBundle extends LightningElement {
  @track products;
  @track bundleName;
  @track bundleDescription;
  @track selectedProductIds = [];
  @track columns = [{ label: "Product Name", fieldName: "Name", type: "text" }];

  @wire(getAvailableProducts)
  wiredProducts({ error, data }) {
    if (data) {
      this.products = data;
    } else if (error) {
      console.error("Error fetching products", error);
    }
  }

  handleNameChange(event) {
    this.bundleName = event.target.value;
  }

  handleDescriptionChange(event) {
    this.bundleDescription = event.target.value;
  }

  handleRowSelection(event) {
    const selectedRows = event.detail.selectedRows;
    this.selectedProductIds = selectedRows.map((row) => row.Id);
  }

  handleCreateBundle() {
    // Assuming createBundle is your method to create the bundle
    console.log(
      "Creating bundle with: ",
      this.bundleName,
      this.bundleDescription,
      this.selectedProductIds
    );
    createBundle({
      productBundleName: this.bundleName,
      productBundleDescription: this.bundleDescription,
      productIds: this.selectedProductIds
    })
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Product Bundle created successfully",
            variant: "success"
          })
        );
        // Additional logic for success scenario
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: "Error creating bundle: " + error.body.message,
            variant: "error"
          })
        );
        // Additional logic for error handling
      });
  }
}
