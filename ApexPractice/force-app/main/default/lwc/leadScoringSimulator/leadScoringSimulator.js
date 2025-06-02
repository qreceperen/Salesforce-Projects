import { LightningElement } from "lwc";
import calculateScoreForSimulation from "@salesforce/apex/LeadScoringController.calculateScoreForSimulation";

export default class LeadScoringSimulator extends LightningElement {
  // All score properties
  totalScore = 0;
  demographicScore = 0;
  behavioralScore = 0;
  engagementScore = 0;
  showScore = false;

  handleCalculateFromChild(event) {
    const formData = event.detail;

    calculateScoreForSimulation({
      industry: formData.industry,
      companySize: formData.companySize,
      emailOpens: formData.emailOpens,
      websiteVisits: formData.websiteVisits
    })
      .then((result) => {
        // Store ALL scores
        this.totalScore = result.totalScore;
        this.demographicScore = result.demographicScore;
        this.behavioralScore = result.behavioralScore;
        this.engagementScore = result.engagementScore;
        this.showScore = true;
      })
      .catch((error) => {
        console.error("❌ Parent: Error:", error);
      });
  }
}
