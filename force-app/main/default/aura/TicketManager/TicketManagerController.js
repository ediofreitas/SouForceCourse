({
    init : function(component, event, helper){
        component.set('v.minDate', helper.getToday());
    },

    handleEventClick : function(component, event, helper){
        const idVooIda = event.getParam('idVooIda');
        const idVooVolta = event.getParam('idVooVolta');
        const recordId = component.get('v.recordId');

        //console.log('entrou' + recordId);

        helper.createTicket(component, recordId, idVooIda, idVooVolta );
        
        //helper.showToast('SUCESSO', idVooIda + idVooVolta, 'success');

    },

    afterScriptsLoaded : function(component, event, helper){
        console.log('Carregado com sucesso');
    },

    handleClick : function(component, event, helper){
        let aeroportoOrigem = component.get('v.aeroportoOrigem');
        let aeroportoDestino = component.get('v.aeroportoDestino');
        let dataPartida = component.get('v.dataPartida');
        let dataRetorno = component.get('v.dataRetorno');

        helper.loadVoos(component, aeroportoOrigem, aeroportoDestino, dataPartida, dataRetorno);
    }
})