import { LightningElement, wire,api } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import getOppMoreThanAmount from '@salesforce/apex/GetAndSetTopOppController.getOppMoreThanAmount';
import updateStage from '@salesforce/apex/GetAndSetTopOppController.updateStage';

export default class WireRefreshApex extends LightningElement {

    @api amount = 500000;
    errorMessage ='';

    @wire(getOppMoreThanAmount, {amount: "$amount"})
    oppts;

    async handleUpdateStage(){
        try{

        await updateStage({amount: this.amount, stageName: "Closed Won"});
        await refreshApex(this.oppts);
        }catch(error){
            this.errorMessage = 'Error Code:' + error.errorCode + ', '
            + 'Error Message: ' + error.errorMessage;
        }

    }

}