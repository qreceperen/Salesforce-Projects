import checkApexTypes from "@salesforce/apex/ApexTypesController.checkApexTypes";
import { LightningElement } from "lwc";

export default class ApexImperativeMethodWithComplexParams extends LightningElement {

    ListItemValue = 4;
    NumberValue = 50;
    StringValue = 'Some String';
    
    message;

  handleStringChange(event) {
    this.StringValue = event.target.value;
  }

  handleNumberChange(event) {
    this.NumberValue = event.target.value;
  }

  handleListItemChange(event) {
    this.ListItemValue = event.target.value;
  }

  async handleButtonClick() {
    let parameterObject = {
        someString: this.StringValue,
        someInteger: this.NumberValue,
        someList: []
    };
    for (let i=0; i<this.ListItemValue;i++) {
        parameterObject.someList.push(this.StringValue);

    }

    try{
        this.message = await checkApexTypes({wrapper:parameterObject});
        this.error = undefined
    } catch(error) {
        this.message = undefined;
        this.error = error;
    }
  }

}
