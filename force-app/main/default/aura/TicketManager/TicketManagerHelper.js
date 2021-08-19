({
    loadVoos : function(component, aeroportoOrigem, aeroportoDestino, dataPartida, dataRetorno) {

        let action = component.get('c.getVoos');

        //String aeroportoOrigem, String aeroportoDestino, String dataPartida, String dataRetorno

        action.setParam("aeroportoOrigem", aeroportoOrigem);
        action.setParam("aeroportoDestino", aeroportoDestino);
        action.setParam("dataPartida", dataPartida);
        action.setParam("dataRetorno", dataRetorno);

        if(!aeroportoOrigem, !aeroportoDestino, !dataPartida, !dataRetorno){
            this.showToast('Ops!', 'Preencha todos os campos', 'error');
        }else{
            action.setCallback(this, function(response){
                let state = response.getState();
    
                if(state == 'SUCCESS'){
                    let modo24h = component.get('v.modo24h');
                    let data = response.getReturnValue();
    
                    if(modo24h){
                        data.forEach(element => {
                            element.vooIda.Hora_de_Chegada__c = Formatter.format(element.vooIda.Hora_de_Chegada__c);    
                            element.vooIda.Hora_de_Partida__c = Formatter.format(element.vooIda.Hora_de_Partida__c);
    
                            element.vooVolta.Hora_de_Chegada__c = Formatter.format(element.vooIda.Hora_de_Chegada__c);    
                            element.vooVolta.Hora_de_Partida__c = Formatter.format(element.vooIda.Hora_de_Partida__c);    
                        });
                    }
                    component.set('v.hasResult', data && data.length);
                    component.set('v.voos', data);
                    if(!data || data.length == 0){
                        this.showToast('Ops!', 'Não foram encontrados voos com os dados solicitados', 'warning');
                    }
                } else if(state == 'ERROR'){
                    this.showToast('Ops!','Houve algum erro no processamento', 'error' );
                    window.console.error(response.getError());
                }
                
            });
    
             $A.enqueueAction(action);
        }
        
    },

    createTicket : function(component, recordId, idVooIda, idVooVolta){
        let action = component.get('c.createTicket');

        action.setParam('accountId', recordId);
        action.setParam('vooIdaId', idVooIda);
        action.setParam('vooVoltaId', idVooVolta);

        action.setCallback(this,function(response){
            let state = response.getState();

            if(state == 'SUCCESS'){
                console.log('ENTROU' + response.getReturnValue());
                //this.showToast('Sucesso', response.getReturnValue(), 'success');
            }else if(state == 'ERROR'){
                console.getError(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    getToday: function () {
        //2021-01-15
       const today = new Date();
       return today.getFullYear() + '-' + ((today.getMonth() + 1) > 10 ? (today.getMonth() + 1) : '0' + (today.getMonth() + 1)) + '-' + (today.getDate() > 10 ? today.getDate() : '0' + today.getDate());
   }
})