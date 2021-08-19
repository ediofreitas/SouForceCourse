import { LightningElement, api} from 'lwc';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
import { loadScript} from 'lightning/platformResourceLoader';
import getVoos from '@salesforce/apex/TicketsController.getVoos';
import createTicket from '@salesforce/apex/TicketsController.createTicket';
import formatterLib from '@salesforce/resourceUrl/Formatter';



export default class TicketManagerLwc extends LightningElement {
    
    @api recordId;
    @api moeda;
    @api modo24h;
    
    aeroportoOrigem;
    aeroportoDestino;
    dtPartida;
    dtRetorno;
    voos;
    minDate;
    hasResult;
    moeda;

    moedas = [
                {label : 'Real', value : 'BRL'},            
                {label : 'Dólar', value : 'USD'},            
                {label : 'Euro', value : 'EUR'}            
    ];

    getToday(){
        //2021-01-15
       const today = new Date();
       return today.getFullYear() + '-' + ((today.getMonth() + 1) > 10 ? (today.getMonth() + 1) : '0' + (today.getMonth() + 1)) + '-' + (today.getDate() > 10 ? today.getDate() : '0' + today.getDate());
   }

    connectedCallback(){
        console.log('MODO' + this.modo24h);
        this.minDate = this.getToday();
        loadScript(this, formatterLib).then(()=>{
            console.log('Carregado com Sucesso!');
        }).catch(error =>{
            console.log(error);
        });
    }

    handlerMoedaChanged(event){
        this.moeda = event.detail.value;
    }
    
    lookupHandlerChange(event){
        if(event.detail.name == 'aeroportoOrigem'){
            this.aeroportoOrigem = event.detail.value;
        }else if(event.detail.name == 'aeroportoDestino'){
            this.aeroportoDestino = event.detail.value;
        }
    }

    handlerDataPartidaChanged(event){
        this.dtPartida = event.detail.value;
    }   
    
    handlerDataRetornoChanged(event){
        this.dtRetorno = event.detail.value;
    }

    handleEventClick(event){

        const idVooIda = event.detail.VooIda;
        const idVooVolta = event.detail.VooVolta;
        
        console.log('EVENTO ' + event.detail.VooIda);
        console.log(idVooIda, idVooVolta);

        this.createTicket(this.recordId, idVooIda, idVooVolta );
        //this.showToast('SUCESSO', idVooIda + idVooVolta, 'success');
        
    }
    
    handleClick(){
        console.log(this.aeroportoOrigem, this.aeroportoDestino, this.dtPartida, this.dtRetorno);
        this.loadVoos(this.aeroportoOrigem, this.aeroportoDestino, this.dtPartida, this.dtRetorno);
    }
    
    loadVoos(aeroportoOrigem, aeroportoDestino, dataPartida, dataRetorno) {
        console.log('PARAMETROS LOAD VOO: ' + aeroportoOrigem + aeroportoDestino + dataPartida + dataRetorno);
        if(!aeroportoOrigem || !aeroportoDestino || !dataPartida || !dataRetorno){
            this.showToast('Ops!', 'Preencha todos os campos', 'error');
        }else{
        getVoos({aeroportoOrigem : aeroportoOrigem,                 
                aeroportoDestino : aeroportoDestino,
                dataPartida : dataPartida,
                dataRetorno : dataRetorno
        }).then(result => {
            console.log('24H' + this.modo24h);
            console.log('RESULT: ' + result);
            if(this.modo24h){
                result.forEach(element => {
                    element.vooIda.Hora_de_Chegada__c = Formatter.format(element.vooIda.Hora_de_Chegada__c);    
                    element.vooIda.Hora_de_Partida__c = Formatter.format(element.vooIda.Hora_de_Partida__c);
                    
                    element.vooVolta.Hora_de_Chegada__c = Formatter.format(element.vooIda.Hora_de_Chegada__c);    
                    element.vooVolta.Hora_de_Partida__c = Formatter.format(element.vooIda.Hora_de_Partida__c);    
                });
            }
            this.hasResult = result && result.length;
            this.voos = result;
            
            if(!result || result.length == 0){
                this.showToast('Ops!', 'Não foram encontrados voos com os dados solicitados', 'warning');
            }
        }).catch(error =>{
            console.log(error);
            this.showToast('Ops!','Houve algum erro no processamento', 'error' );
                })
                
            }
    }        
    createTicket(recordId, idVooIda, idVooVolta){
                console.log('ENTROU' + idVooIda + idVooVolta);
                createTicket({accountId : recordId,
                    vooIdaId : idVooIda,
                    vooVoltaId : idVooVolta
                }).then(result =>{
                    this.showToast('Sucesso', 'Ticket reservado com sucesso!', 'success');
                }).catch(error =>{
                    this.showToast('Ops!', 'Houve algum problema', 'success');
                    console.error(error);
                });
    }
            
    showToast(title, message, variant) {
                const toast = new ShowToastEvent({
                    title : title,
                    message : message,
                    variant : variant
                });
                this.dispatchEvent(toast);   
    }
            
            
}