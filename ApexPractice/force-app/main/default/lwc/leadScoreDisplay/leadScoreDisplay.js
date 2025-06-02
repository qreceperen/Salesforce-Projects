import { LightningElement, api } from "lwc";

export default class LeadScoreDisplay extends LightningElement {
  @api totalScore = 0;
  @api demographicScore = 0;
  @api behavioralScore = 0;
  @api engagementScore = 0;
  @api showScore = false;
}
