public with sharing class modalEnderecoController {
   

    @AuraEnabled
    public static Endereco getEndereco(String cep){

        return EnderecoService.getEndereco(cep);

    }

    @AuraEnabled
    public static void updateEndereco(String accountId, String cep, String rua, String bairro, String cidade, String estado){
        Account acc = new Account(Id = accountId);

        acc.Cep__c = cep;
        acc.Rua__c = rua;
        acc.Bairro__c = bairro;
        acc.Cidade__c = cidade;
        acc.Estado__c = estado;

        update acc;

    }
}