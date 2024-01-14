import { LightningElement, track, wire } from 'lwc';
import getOpportunityStages from '@salesforce/apex/OpportunityController.getOpportunityStages';
import getOpportunitiesByStage from '@salesforce/apex/OpportunityController.getOpportunitiesByStage';
import updateOpportunityStage from '@salesforce/apex/OpportunityController.updateOpportunityStage';

export default class OpportunityPipeline extends LightningElement {
    @track stageNames = [];
    @track opportunitiesByStage = {};

    @wire(getOpportunityStages)
    wiredStages({ error, data }) {
        if (data) {
            this.stageNames = data;
        } else if (error) {
            console.error('Error fetching stages: ', error);
        }
    }

    @wire(getOpportunitiesByStage)
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunitiesByStage = data;
        } else if (error) {
            console.error('Error fetching opportunities: ', error);
        }
    }

    get stagesWithOpportunities() {
        return this.stageNames.map(stage => ({
            name: stage,
            opportunities: this.opportunitiesByStage[stage] || []
        }));
    }

    handleDragOver(event) {
        event.preventDefault();
    }

    handleDragStart(event) {
      event.dataTransfer.setData('text', event.target.dataset.id);
  }
  

    handleDrop(event) {
        event.preventDefault();
        const opportunityId = event.dataTransfer.getData('opportunity_id');
        const stageName = event.currentTarget.dataset.stage;
        this.updateOpportunityStage(opportunityId, stageName);
    }

    updateOpportunityStage(opportunityId, stageName) {
        updateOpportunityStage({ opportunityId, stageName })
            .then(() => {
                // Handle successful update
                // You might want to refresh the data or give user feedback
            })
            .catch(error => {
                console.error('Error updating opportunity stage: ', error);
                // Handle errors, possibly by informing the user
            });
    }
}
