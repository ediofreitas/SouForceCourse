import { LightningElement, api, track, wire } from 'lwc';
import getDado from '@salesforce/apex/lookupfieldController.getObjectDetails';

export default class CardTicketLwc extends LightningElement {
    @api recordId;
    @api objectApiName;

    @track mensagem = 'Olá mundo';

    @wire (getDado, {ObjectName: '$objectApiName'})
    record;
    
    connectedCallback(){
        console.log(this.recordId);

    }
    handleClick(event){
        this.mensagem = 'Você clicou no botão'
    }
}