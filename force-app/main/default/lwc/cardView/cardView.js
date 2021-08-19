import { LightningElement } from 'lwc';

export default class CardView extends LightningElement {

    handleClickEvent(event){
        console.log(event.detail.param1);
        console.log(event.detail.param2);
    }
}