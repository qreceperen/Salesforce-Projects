import { LightningElement, api, track } from 'lwc';

export default class OrderProductForm extends LightningElement {
    @api productOptions = [];
    @track selectedProductId = '';
    @track orderQuantity;

    
}