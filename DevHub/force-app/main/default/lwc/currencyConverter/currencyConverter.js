import { LightningElement,track } from 'lwc';
import getCurrencyData from '@salesforce/apex/currencyAPI.getCurrencyData';

export default class CurrencyConverter extends LightningElement {
    @track currencyFrom;
    @track currencyTo;
    @track amount;
    @track result;

    handleCurrencyFromChange(event){
        this.currencyFrom = event.target.value;
    }

    handleCurrencyToChange(event){
        this.currencyTo = event.target.value;
    }

    handleAmountChange(event){
        this.amount = event.target.value;
    }
    handleConvert(){
        getCurrencyData({currencyFrom:this.currencyFrom,currencyTo: this.currencyTo, amount: this.amount})
        .then(data=> {
            this.result = data;
        })
        .catch(error => {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            console.error('Error in getting conversion rate:', message);
        });
    }
 
}