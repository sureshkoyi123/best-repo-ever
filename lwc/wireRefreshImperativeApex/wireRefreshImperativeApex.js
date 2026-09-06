import { LightningElement, api, wire } from 'lwc';
import updateAccountName from '@salesforce/apex/UpdateAccountNameController.updateAccountName';
import {getFieldValue, getRecord, notifyRecordUpdateAvailable} from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
export default class WireRefreshImperativeApex extends LightningElement {
    @api recordId;
    @wire(getRecord, {recordId: "$recordId", fields: NAME_FIELD})
    account;

    get name(){
        return this.account.data? getFieldValue(this.account.data, NAME_FIELD): "";
    }

    async handleUpdateName(){

        await updateAccountName({recordId: this.recordId});
        notifyRecordUpdateAvailable([{recordId: this.recordId}]);
    }

}