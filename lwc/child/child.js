import { LightningElement, api } from 'lwc';

export default class Child extends LightningElement {
    static shadowSupportMode = 'native'; // enforces composed:false properly
     @api 
        childMessage = 'Hello';
    handleClick(event){
      
        const customEvent = new CustomEvent('childclick'
            );
        this.dispatchEvent(customEvent);

    }

}