public class ImportDataController {
    @AuraEnabled
    public static void importSampleData() {
 	delete [SELECT Id from Localizacao__c];
    delete [SELECT Id from Aeroporto__c];
    delete [SELECT Id from Voo__c];
        
        //Insert Pais
        StaticResource locResourcePais = [SELECT Id, Body from StaticResource WHERE Name = 'localizacao_pais'];
        List<Object> locPaisesList = (List<Object>) JSON.deserializeUntyped(locResourcePais.body.toString());
        List<Localizacao__c> locPaisToInsert = new List<Localizacao__c>();
        Map<String, Id> mapToInsert = new Map<String, Id>();
        
        for(Object locPais : locPaisesList) {
            Localizacao__c loc = new Localizacao__c();
            Map<String, Object> mapLoc = (Map<String, Object>)locPais;
            loc.Name = (String)mapLoc.get('Name');
            loc.RecordTypeId = Schema.SObjectType.Localizacao__c.getRecordTypeInfosByName().get('País').getRecordTypeId();
            locPaisToInsert.add(loc);
        }
      
        insert locPaisToInsert;
        
        for(Localizacao__c loc : locPaisToInsert) {
            mapToInsert.put(loc.Name, loc.Id);
        }
        
        //Insert Estado
        List<Localizacao__c> locEstadoToInsert = new List<Localizacao__c>();
        StaticResource locResourceEstado = [SELECT Id, Body from StaticResource WHERE Name = 'localizacao_estado'];
        List<Object> locEstadoList = (List<Object>) JSON.deserializeUntyped(locResourceEstado.body.toString());
        
        for(Object locEstado : locEstadoList) {
            Localizacao__c loc = new Localizacao__c();
            Map<String, Object> mapLoc = (Map<String, Object>)locEstado;
            loc.Name = (String)mapLoc.get('Name');
            loc.Pertence__c = mapToInsert.get((String)mapLoc.get('Pais'));
            loc.RecordTypeId = Schema.SObjectType.Localizacao__c.getRecordTypeInfosByName().get('Estado').getRecordTypeId();
            locEstadoToInsert.add(loc);
        }
        
        insert locEstadoToInsert;
        
        for(Localizacao__c loc : locEstadoToInsert) {
            mapToInsert.put(loc.Name, loc.Id);
        }
        
        //Insert Aeroporto
        List<Aeroporto__c> aeroToInsert = new List<Aeroporto__c>();
        StaticResource aeroResource = [SELECT Id, Body from StaticResource WHERE Name = 'aeroportos'];
        List<Object> aeroList = (List<Object>) JSON.deserializeUntyped(aeroResource.body.toString());
        
        for(Object aero : aeroList) {
            Aeroporto__c a = new Aeroporto__c();
            Map<String, Object> mapAero = (Map<String, Object>)aero;
            a.Name = (String)mapAero.get('Name');
            a.Pais__c = mapToInsert.get((String)mapAero.get('Pais'));
            a.Estado__c = mapToInsert.get((String)mapAero.get('Estado'));
            a.Sigla__c = (String)mapAero.get('Sigla');
            aeroToInsert.add(a);
        }
        
        insert aeroToInsert;
        
        for(Aeroporto__c ae : aeroToInsert) {
            mapToInsert.put(ae.Sigla__c, ae.Id);
        }
        
        //Insert Voo
        List<Voo__c> vooToInsert = new List<Voo__c >();
        StaticResource vooResource = [SELECT Id, Body from StaticResource WHERE Name = 'voos'];
        List<Object> vooList = (List<Object>) JSON.deserializeUntyped(vooResource.body.toString());
        
        for(Object voo : vooList) {
            Voo__c vo = new Voo__c();
            Map<String, Object> mapVoo = (Map<String, Object>)voo;
            vo.Aeroporto_Partida__c = mapToInsert.get((String)mapVoo.get('AeroPartida'));
            vo.Aeroporto_Chegada__c = mapToInsert.get((String)mapVoo.get('AeroChegada'));
            vo.Data_Partida__c = (Date)JSON.deserialize((String)mapVoo.get('DataPartida'), Date.class);
            vo.Data_Chegada__c = (Date)JSON.deserialize((String)mapVoo.get('DataChegada'), Date.class);
            vo.Companhia__c  = (String)mapVoo.get('Companhia');
            vo.Duracao__c  = (String)mapVoo.get('Duracao');
            vo.Hora_de_Partida__c  = (String)mapVoo.get('HoraPartida');
            vo.Hora_de_Chegada__c  = (String)mapVoo.get('HoraChegada');
            vo.Assento__c = (String)mapVoo.get('Assento');
            vo.Valor__c = (Decimal)mapVoo.get('Valor');
            vooToInsert.add(vo);
        }
        
        insert vooToInsert;
        
        for(Voo__c v : vooToInsert) {
            mapToInsert.put(v.Name, v.Id);
        }
    }
    
}