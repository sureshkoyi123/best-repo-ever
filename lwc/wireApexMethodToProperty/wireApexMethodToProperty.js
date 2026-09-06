import { LightningElement, wire } from 'lwc';
import getTopTenContacts from '@salesforce/apex/TopTenContactController.getTopTenContacts';

export default class WireApexMethodToProperty extends LightningElement {

    @wire(getTopTenContacts, {})
    contacts;
}