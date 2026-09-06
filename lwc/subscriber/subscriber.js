import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import SAMPLEMC from '@salesforce/messageChannel/SampleMessageChannel__c';

export default class Subscriber extends LightningElement {
    @wire(MessageContext)
    messageContext;

    subscription = null;
    message = 'Waiting......';

    // Using renderedCallback guarantees subscription happens after component DOM attach
    renderedCallback() {
        if (this.messageContext && !this.subscription) {
            this.subscribeToMessageChannel();
        }
    }

    subscribeToMessageChannel() {
        console.log('Subscriber: Subscribing to channel...');
        this.subscription = subscribe(
            this.messageContext,
            SAMPLEMC,
            (payload) => this.handleMessage(payload),
            { scope: APPLICATION_SCOPE }
        );
        console.log('Subscriber: Subscription established:', this.subscription);
    }

    handleMessage(payload) {
        console.log('Subscriber: Raw payload received:', JSON.stringify(payload));
        this.message = payload?.message ?? 'No message property found in payload';
    }
}