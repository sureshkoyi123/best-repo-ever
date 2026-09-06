import { LightningElement } from 'lwc';
import {createRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNT_OBJ from '@salesforce/schema/Account'
export default class CreateFormCustomUI extends LightningElement {

accountId;
name = '';
handleNameChange(event){
    this.accountId = undefined;
    this.name = event.target.value;
}
async handleCreateRecord(){
  
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        const recordInput = {apiName: ACCOUNT_OBJ.objectApiName, fields};
          try{
            const newRecord = await createRecord(recordInput); 
            this.accountId = newRecord.id;
            this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Account created',
                            variant: 'success'
                        })
                    );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Error',
                    variant: 'error'
                })
            );
}

}
}