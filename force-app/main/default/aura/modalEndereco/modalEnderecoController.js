({
    myAction : function(component, event, helper) {

    },

    handleClick : function(component, event, helper){
        let action = component.get('c.getEndereco')
        let cep = component.get('v.cep');

        action.setParam('cep', cep);
        action.setCallback(this, function(response){
            let state = response.getState();

            if(state == 'SUCCESS'){
                let data = response.getReturnValue();

                component.set('v.tipoDeEndereco', data.address_type);
                component.set('v.rua', data.address_name);
                component.set('v.endereco', data.address) ;
                component.set('v.estado', data.state);
                component.set('v.bairro', data.district); 
                component.set('v.cidade', data.city);
                component.set('v.ibge', data.city_ibge);
                component.set('v.ddd', data.ddd); 
                component.set('v.latitude', data.lat); 
                component.set('v.longitude', data.lng);

                console.log('entrou');
                helper.showToast('Sucesso', state, 'success');
            }else if(state == 'ERROR'){
                helper.showToast('Erro', state, 'error');
                console.getError(response.getError());
            }else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },

    handleSubmit : function(component, event, helper){
        let action = component.get('c.updateEndereco');
        let recordId = component.get('v.recordId');
        let cep = component.get('v.cep');
        let rua = component.get('v.rua');
        let bairro = component.get('v.bairro');
        let cidade = component.get('v.cidade');
        let estado = component.get('v.estado');

        action.setParam('accountId', recordId);
        action.setParam('cep', cep);
        action.setParam('rua', rua);
        action.setParam('bairro', bairro);
        action.setParam('cidade', cidade);
        action.setParam('estado', estado);

        action.setCallback(this, function(response){
            let state = response.getState();

            if(state == 'SUCCESS'){
                console.log('entrou');
                helper.showToast('Sucesso', 'Seu endereço foi atualizado com sucesso', 'success');
                let dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }else if(state == 'ERROR'){
                helper.showToast('Erro', state, 'error');
                console.getError(response.getError());
            }
        });
        $A.enqueueAction(action);

        
    }
})