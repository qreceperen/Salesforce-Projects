import { LightningElement, wire, track } from "lwc";
import getInventoryProducts from "@salesforce/apex/InventoryProductController.getInventoryProducts";
import createOrderItem from "@salesforce/apex/InventoryProductController.createOrderItem";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from '@salesforce/apex';
const COLUMNS = [
  { label: "Product Name", fieldName: "Name" },
  { label: "Stock Quantity", fieldName: "Stock_Quantity__c", type: "Number" },
  { label: "Unit Price", fieldName: "Unit_Price__c", type: "currency" }
];
{
}

export default class InventoryProducts extends LightningElement {
  inventoryProducts;
  error;
  columns = COLUMNS;
  @track productOptions = [];
  @track selectedProductId = "";
  @track orderQuantity;
  wiredInventoryResult;

  @wire(getInventoryProducts)
  wiredInventoryProducts(result) {
      this.wiredInventoryResult = result;
      const { error, data } = result;
      if (data) {
          this.inventoryProducts = data;
          this.error = undefined;

          this.productOptions = data.map(product => ({
              label: product.Name,
              value: product.Id
          }));
          console.log('Product Options:', JSON.stringify(this.productOptions));
      } else if (error) {
          this.error = error;
          this.inventoryProducts = undefined;
      }
  }

  handleProductChange(event) {
    this.selectedProductId = event.detail.value;
    console.log("Selected Product Id " + this.selectedProductId);
  }

  handleQuantityChange(event) {
    this.orderQuantity = event.target.value;
    console.log("Selected Product Id " + this.orderQuantity);
  }

  handlePlaceOrder() {
    // Validate inputs
    if (!this.selectedProductId || !this.orderQuantity) {
        this.showToast('Error', 'Please select a product and enter a valid quantity.', 'error');
        return;
    }

    // Call Apex to create the Order Item
    createOrderItem({ productId: this.selectedProductId, orderQuantity: parseInt(this.orderQuantity, 10) })
        .then(() => {
            this.showToast('Success', 'Order placed successfully.', 'success');
            // Refresh the product list to reflect updated quantities
            return refreshApex(this.wiredInventoryResult);
        })
        .catch(error => {
            this.showToast('Error', error.body.message, 'error');
        });
}

  showToast(title, message, variant) {
    const evt = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(evt);
  }
}
