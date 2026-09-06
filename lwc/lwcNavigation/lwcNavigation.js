import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class LwcNavigation extends NavigationMixin(LightningElement) {
    
    handleButtonClick() {
        try{
            this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'list'
            },
        state: {
        filterName: 'Recent' // or a specific ListView ID
        }
        });
    }
    catch(error)
        
    {
        console.log('Error: ' + error);
    }
}
}