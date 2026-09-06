import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import SAMPLEMC from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class Publisher extends LightningElement {
    @wire(MessageContext)
    messageContext;

    handleClick() {
        console.log('1. Publisher button clicked.');
        
        if (!this.messageContext) {
            console.error('Publisher: MessageContext is missing!');
            return;
        }

        const payload = { message: 'Hello from Publisher!' };
        
        console.log('2. Publishing payload:', JSON.stringify(payload));
        publish(this.messageContext, SAMPLEMC, payload);
        console.log('3. Publish function executed successfully.');
    }
}