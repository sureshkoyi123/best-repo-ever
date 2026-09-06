import { LightningElement, api } from 'lwc';

export default class Tile extends LightningElement {
    @api product;

    tileClick() {
        this.dispatchEvent(
            new CustomEvent('tileclick', { detail: this.product.fields.Id.value })
        );
    }
}