import { LightningElement } from 'lwc';
import { bikes } from 'c/data';

export default class List extends LightningElement {
    bikes = bikes;

    handleTileClick(event) {
        this.dispatchEvent(
            new CustomEvent('productselected', { detail: event.detail })
        );
    }
}