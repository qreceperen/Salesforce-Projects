import { LightningElement } from "lwc";

export default class LeadScoringForm extends LightningElement {
  // Form data (same as before)
  industry = "";
  companySize = "";
  emailOpens = 0;
  websiteVisits = 0;

  // Dropdown options (same as before)
  industryOptions = [
    { label: "Technology", value: "Technology" },
    { label: "Healthcare", value: "Healthcare" },
    { label: "Finance", value: "Finance" },
    { label: "Manufacturing", value: "Manufacturing" },
    { label: "Retail", value: "Retail" }
  ];

  companySizeOptions = [
    { label: "Small (1-50)", value: "Small (1-50)" },
    { label: "Medium (51-500)", value: "Medium (51-500)" },
    { label: "Large (501-2000)", value: "Large (501-2000)" },
    { label: "Enterprise (2000+)", value: "Enterprise (2000+)" }
  ];

  // Change handlers (same as before)
  handleIndustryChange(event) {
    this.industry = event.detail.value;
  }

  handleCompanySizeChange(event) {
    this.companySize = event.detail.value;
  }

  handleEmailOpensChange(event) {
    this.emailOpens = event.detail.value;
  }

  handleWebsiteVisitsChange(event) {
    this.websiteVisits = event.detail.value;
  }

  // 🔥 THE MAGIC PART - Send data to Parent!
  handleCalculate() {
    console.log("Child: Calculate button clicked, sending data to parent...");

    // Create the data to send
    const formData = {
      industry: this.industry,
      companySize: this.companySize,
      emailOpens: parseInt(this.emailOpens),
      websiteVisits: parseInt(this.websiteVisits)
    };

    console.log("Child: Sending this data:", formData);

    // 🚀 FIRE CUSTOM EVENT TO PARENT
    const calculateEvent = new CustomEvent("calculate", {
      detail: formData
    });

    this.dispatchEvent(calculateEvent);
    console.log("Child: Event fired to parent!");
  }
}
