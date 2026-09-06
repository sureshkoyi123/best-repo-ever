import { LightningElement, wire } from 'lwc';
import getWeather from '@salesforce/apexContinuation/ContinuationController.getWeather';

export default class GetWeather extends LightningElement {
    imperativeContinuation;
    wiredWeather;
    error;
 @wire(getWeather)
wiredContinuation({ data, error }) {
    if (data) {
        // Sanitize the string: Remove Byte Order Marks (\uFEFF) and trim whitespace
        const cleanData = typeof data === 'string' 
            ? data.replace(/^\uFEFF/, '').trim() 
            : data;

        try {
            // Attempt to parse if it's JSON, otherwise fall back to the clean string
            const parsed = JSON.parse(cleanData);
            this.wiredWeather = JSON.stringify(parsed, null, 2);
        } catch (e) {
            // If it's the HTML payload, it safely renders as raw text now
            this.wiredWeather = cleanData;
        }
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.wiredWeather = undefined;
    }
}

    async callContinuation(){
        try{
        this.imperativeContinuation = await getWeather();
        this.error = undefined;
        }
        catch(error){
            this.error = error;
            this.imperativeContinuation = undefined;

        }

        
    }

    get formatedImperativeResult(){
        if (!this.imperativeContinuation) {
            return '';
        }
        return JSON.stringify(this.imperativeContinuation);
    }
    get formattedError(){
        if (!this.error) {
            return '';
        }
        return JSON.stringify(this.error);
    }
}