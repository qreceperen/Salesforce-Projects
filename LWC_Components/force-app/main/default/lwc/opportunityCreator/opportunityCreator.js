import { LightningElement, track, wire } from 'lwc';
import createOpportunity from '@salesforce/apex/OpportunityService.createOpportunity';
import getOpportunityStagePicklistValues from '@salesforce/apex/OpportunityService.getOpportunityStagePicklistValues';

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
}
