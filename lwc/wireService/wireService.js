import { LightningElement, api, wire } from 'lwc';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
//import ACCOUNT_NUMBER_FIELD from '@salesforce/schema/Account.AccountNumber';
import ANNUALREVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import { getRecord } from 'lightning/uiRecordApi';

export default class WireService extends LightningElement {
    @api recordId;
    record;
    error;


    @wire(getRecord, {recordId: "$recordId", fields: [ACCOUNT_NAME_FIELD, ANNUALREVENUE_FIELD] })
    wiredRecord({data, error}){
        if(data){
            this.record = data;
            this.error = undefined;
        }
        else if(error){
            this.error = error;
            this.record = undefined;
        }
        
    }
    get accountName(){
            return this.record.fields.Name.value;
    }
    get annualRevenue(){
        return this.record.fields.AnnualRevenue.value;
    }




}