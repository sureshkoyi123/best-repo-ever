import { LightningElement, api, wire } from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
const FIELDS=["Contact.Name", "Contact.Phone","Contact.Email", "Contact.Title"];

export default class WireGetRecordApi extends LightningElement {
    @api recordId;
    
    @wire(getRecord,{recordId: "$recordId", fields: FIELDS})
    contact;

    get name(){
        return getFieldValue(this.contact.data, "Contact.Name");

    }
    get title(){
        return getFieldValue(this.contact.data, "Contact.Title");
        
    }

    get phone(){
        return getFieldValue(this.contact.data, "Contact.Phone");
    }
    get email(){
       
        return this.contact.data.fields.Email.value;
    }
}