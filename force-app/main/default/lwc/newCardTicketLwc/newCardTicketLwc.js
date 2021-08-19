import { LightningElement, api } from 'lwc';

export default class NewCardTicketLwc extends LightningElement {

    @api vooIda;
    @api vooVolta;
    @api moeda;

    reservaHandleClick(){
        console.log('reservou');
        let cmpEvent = new CustomEvent('ticketeventclick', {
            detail : {
                vooIda : this.vooIda,
                vooVolta : this.vooVolta
            }
        });
        this.dispatchEvent(cmpEvent);
    }

    get diaDiferenteIda(){
        return this.vooIda.Data_Partida__c != this.vooIda.Data_Chegada__c;
    }

    get diaDiferenteVolta(){
        return this.vooVolta.Data_Partida__c != this.vooVolta.Data_Chegada__c;
    }

    get valorTotal(){
        return this.vooIda.Valor__c + this.vooVolta.Valor__c;
    }
}