import { LightningElement } from 'lwc';
import counterManager from './counterManager';
export default class SimpleCounter extends LightningElement {
    counter = counterManager(100);
    handleIncrement(){
        this.counter.value.increment();
    }
}