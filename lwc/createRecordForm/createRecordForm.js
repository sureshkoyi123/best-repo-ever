import { LightningElement,api } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ACCOUNT_FIELD from '@salesforce/schema/Account.Name';
import WEBSITE_FIELD from '@salesforce/schema/Account.Website';

export default class CreateRecordForm extends LightningElement {

objectApiName = ACCOUNT_OBJECT;
nameField = ACCOUNT_FIELD;
websiteField = WEBSITE_FIELD;
fields = [ACCOUNT_FIELD, WEBSITE_FIELD];
nameDefaultValue = "Accenture";

}