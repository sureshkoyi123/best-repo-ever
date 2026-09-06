import { LightningElement, wire } from 'lwc';
import checkApexTypes from '@salesforce/apex/ApexCustomTypesController.checkApexTypes';

export default class WireApexMethodWithObjectParam extends LightningElement {
listItemValue = 0;
numberValue=99;
stringValue="Some string";

paramObject = {
    someInt: this.numberValue,
    someStr: this.stringValue,
    someList: []
}

@wire(checkApexTypes, {wrapper: '$paramObject'})
apexResponse;


handleStringChange(event){
    this.paramObject = {...this.paramObject, someStr:(this.stringValue = event.target.value)};
}
handleNumberChange(event){
this.paramObject = {...this.paramObject, someInt: (this.numberValue = parseInt(event.target.value, 10))};
}

handleListChange(event){
const someList = [];
for(let i=0; i<event.target.value;i++){
    someList.push(this.stringValue);
    
}
this.paramObject = {...this.paramObject, someList}

}
}