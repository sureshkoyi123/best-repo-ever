//customProvider.js
import { LightningElement, api } from "lwc";
import customPicture from "./customPicture.html";

export default class CustomProvider extends LightningElement {
  @api
  getDataTypes() {
    return {
      customPictureType: {
        template: customPicture,
        standardCellLayout: true,
        typeAttributes: ["pictureUrl"],
      },
      // Other custom types here
    };
  }
}