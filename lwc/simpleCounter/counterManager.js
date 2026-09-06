import {defineState} from '@lwc/state';
const counterManager = defineState(
    ({atom, computed, setAtom}, initialValue=0)=>{
        const count = atom(initialValue);
        const increment = ()=>{
            setAtom(count, count.value+1);
        };
        return {
            count, increment,
        };
    },

);
export default counterManager;