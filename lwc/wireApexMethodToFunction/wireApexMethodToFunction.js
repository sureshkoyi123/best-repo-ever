import { LightningElement, wire } from 'lwc';
import getTopFiveContacts from '@salesforce/apex/GetTopFiveContactController.getTopFiveContacts';

export default class WireApexMethodToFunction extends LightningElement {
    contacts;
    error;

    async handleLoad(){
        try{
        this.contacts = await getTopFiveContacts();
        this.error = undefined;
        }
    
    catch(error){
        this.error = error;
        this.contacts = undefined;

    }
    }
/* 
 @wire(getTopFiveContacts)
    wiredContacts({data, error}){
        if(data){
            this.contacts = data;
            this.error = undefined;
        }
        else if(error){
            this.error = error;
            this.contacts = undefined;
        }

    }  */
}