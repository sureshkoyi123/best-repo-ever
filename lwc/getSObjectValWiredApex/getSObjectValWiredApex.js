import { LightningElement, wire } from 'lwc';
import {getSObjectValue} from '@salesforce/apex';
import getContact from '@salesforce/apex/GetSingleContactController.getContact';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
export default class GetSObjectValWiredApex extends LightningElement {
    
    @wire (getContact, {})
    contact;

    get name(){
        return this.contact.data? getSObjectValue(this.contact.data.NAME_FIELD): "";
    }
}