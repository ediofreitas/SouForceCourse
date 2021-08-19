({
    reservaHandleClick : function(component, event, helper) {
        let cmpEvent = component.getEvent('ticketEventClick');
        let vooIda = component.get('v.vooIda');
        let vooVolta = component.get('v.vooVolta');

        //console.log('HANDLECLICK' + vooIda.Id, vooVolta.Id);

        cmpEvent.setParam("idVooIda", vooIda.Id);
        cmpEvent.setParam("idVooVolta", vooVolta.Id);

        cmpEvent.fire();
    }

    
})