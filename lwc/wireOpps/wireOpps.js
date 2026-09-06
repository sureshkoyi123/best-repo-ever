import { LightningElement, api, wire, track } from 'lwc';
import getTopTenOpps from '@salesforce/apex/TopTenOpportunityController.getTopTenOpps';
import NAME_FIELD from '@salesforce/schema/Opportunity.Name';
import AMOUNT_FIELD from '@salesforce/schema/Opportunity.Amount';
import STAGE_NAME_FIELD from '@salesforce/schema/Opportunity.StageName';

const COLS = [
    {
        label: "Name",
        fieldName: NAME_FIELD.fieldApiName
    },
    {
        label: "Amount",
        fieldName: AMOUNT_FIELD.fieldApiName
    },
    {
        label: "Stage Name",
        fieldName: STAGE_NAME_FIELD.fieldApiName,
        editable: true
    }
];
export default class WireOpps extends LightningElement {
@api recordId;

error;
columns = COLS;


@wire(getTopTenOpps, {recordId: "$recordId"})
opps;
}