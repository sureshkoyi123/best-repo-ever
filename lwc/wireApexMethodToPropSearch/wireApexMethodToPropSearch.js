import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/GetContactController.getContacts';

const DELAY = 400;
export default class WireApexMethodToPropSearch extends LightningElement {

    searchKey = '';
    contacts;
    error;
  /*   @wire(getContacts, {searchKey: '$searchKey'})
    contacts; */

    async handleSearch(){
        try{
            this.contacts = await getContacts({searchKey: this.searchKey});
            this.error = undefined;
        }
        catch(error){
            this.error = error;
            this.contacts = undefined;

        }
    }

    handleChange(event){

        window.clearTimeout(this.delayTimeOut);
        const searchKey = event.target.value;
        this.delayTimeOut = setTimeout(()=>
            {
                this.searchKey = searchKey;

            }, DELAY);

    }

}