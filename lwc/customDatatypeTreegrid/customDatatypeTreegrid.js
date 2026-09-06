// customDatatypeTreegrid.js
import LightningTreeGrid from "lightning/treeGrid";
import customNameTemplate from "./customName.html";
import customNumberTemplate from "./customNumber.html";

export default class CustomDatatypeTreegrid extends LightningTreeGrid {
  static customTypes = {
    customName: {
      template: customNameTemplate,
      typeAttributes: ["industryName"],
      standardCellLayout: true,
    },
    customNumber: {
      template: customNumberTemplate,
      typeAttributes: ["min"],
      cellAttributes: {
      class: "slds-theme_shade slds-theme_alert-texture",
    },
    },
  };
}