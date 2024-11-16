import { LightningElement, track, wire } from 'lwc';
import inventoryProductMethod  from '@salesforce/apex/InventoryProductController2.getInventoryProducts';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    { label: 'Product Name', fieldName: 'Name' },
    { label: 'Stock Quantity', fieldName: 'Stock_Quantity__c', type: 'Number' },
    { label: 'Unit Price', fieldName: 'Unit_Price__c', type: 'currency' }
];

export default class OrderProductForm extends LightningElement {
    inventoryProducts;
    error;
    columns = COLUMNS;
    selectedProductId = '';
    orderQuantity;

    @wire(inventoryProductMethod)
    wiredInventoryProducts({ error, data }) {
        if (data) {
            this.inventoryProducts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.inventoryProducts = undefined;
        }
    }
}
