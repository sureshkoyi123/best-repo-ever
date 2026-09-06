import { LightningElement } from 'lwc';

export default class Parent extends LightningElement {
    message='';
    handleChildClick(event){
        //event.stopPropagation();    
        this.message = event.target.childMessage;
        
    }
        
        
}