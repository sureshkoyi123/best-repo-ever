// customDataTypeNumber.js
import { LightningElement, api } from "lwc";

export default class CustomDataTypeNumber extends LightningElement {
  @api value;

  get computedClass() {
    return this.value > 100000000 ? "slds-text-color_success" : "slds-text-color_error";
  }

  get computedIcon() {
    return this.value > 100000000 ? "utility:arrowup" : "utility:arrowdown";
  }

  get iconVariant() {
    return this.value > 100000000 ? "success" : "error";
  }
}