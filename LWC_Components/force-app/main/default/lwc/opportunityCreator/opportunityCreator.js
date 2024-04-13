import { LightningElement, track, wire } from 'lwc';
import createOpportunity from '@salesforce/apex/OpportunityService.createOpportunity';
import getOpportunityStagePicklistValues from '@salesforce/apex/OpportunityService.getOpportunityStagePicklistValues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OpportunityCreator extends LightningElement {
    @track stageOptions;
    @track opportunityData = {};
    currentStep = 1;

    @wire(getOpportunityStagePicklistValues)
    wiredStageValues({ error, data }) {
        if (data) {
            this.stageOptions = data.map((value) => ({
                label: value,
                value: value
            }));
        } else if (error) {
            console.log('Error retrieving stage picklist values: ', error);
        }
    }

    get stepVisibility() {
        return {
            isFirstStep: this.currentStep === 1,
            isSecondStep: this.currentStep === 2,
            isThirdStep: this.currentStep === 3
        };
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        this.opportunityData[field] = event.target.value;
    }

    goToNextStep() {
        this.currentStep++;
    }

    goToPreviousStep() {
        this.currentStep--;
    }

    saveOpportunity() {
        const oppFields = {
            Name: this.opportunityData.Name,
            Amount: this.opportunityData.Amount,
            CloseDate: this.opportunityData.CloseDate,
            StageName: this.opportunityData.Stage,
            Description: this.opportunityData.Description
        };
        // console.log('Opp Field- '+ oppFields);
        createOpportunity({ oppData: oppFields })
            .then((result) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Opportunity created Successfully',
                        variant: 'success'
                    }),
                );
                
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating Opportunity',
                        message: error.body.message,
                        variant: 'error'
                    }),
                );
            });
    }
}
