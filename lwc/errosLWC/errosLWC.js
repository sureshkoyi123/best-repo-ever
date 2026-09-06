import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class ErrosLWC extends LightningElement {
    @api greeting = 'Hello';

    handleChange(event){

        try{
            throw new Error("Something went wrong!!");
        }
        catch(e){

        this.dispatchEvent(
            new ShowToastEvent(
                {
                    title: "something went wrong",
                    message: e.message,
                    variant:"error",
                }
            )
        );
    }

    }
}