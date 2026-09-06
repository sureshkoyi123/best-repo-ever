import { LightningElement } from 'lwc';

export default class GrandParent extends LightningElement {
    message='';
    handleChildEvent(event){
        this.message = event.detail.message;
    }
}