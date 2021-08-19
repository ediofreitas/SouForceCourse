@RestResource(urlMapping='/Escola')
global with sharing class EscolaREST {
    @httpGet
    global static List<Escola__c> getEscolas(){
        return [SELECT Id, Name, Idioma__c, Valor_por_semana_general__c, Valor_por_semana_part_time__c  FROM Escola__c];
    }

    @httpPost
    global static List<Escola__c> insertEscolas(List<Escola__c> escolas){
        insert escolas;

        return escolas;
    }

    @httpPut
    global static List<Escola__c> upsertEscolas(List<Escola__c> escolas){
        upsert escolas;

        return escolas;
    }

    @httpPatch
    global static List<Escola__c> updateEscolas(List<Escola__c> escolas){
        update escolas;

        return escolas;
    }

    @httpDelete
    global static Boolean deleteEscolas(){
        try {
            Id idEscola = (Id)RestContext.request.params.get('Id');
            Escola__c escolaToDelete = new Escola__c(Id = idEscola);
        delete escolaToDelete;

        return true;

        } catch (Exception ex) {
            return false;
        }
        
    }




}