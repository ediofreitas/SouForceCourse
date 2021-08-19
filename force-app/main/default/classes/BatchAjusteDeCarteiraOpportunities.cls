@IsTest
public with sharing class BatchAjusteDeCarteiraOpportunitiesTest {
    

    @TestSetup
    static void makeData(){
        id userId = UserInfo.getUserId();
        String CNPJ14_RECTYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CNPJ-14').getRecordTypeId();
        String CNPJ8_RECTYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CNPJ-08').getRecordTypeId();

        Porte__c porte = new Porte__c(Name = 'GR TOP1',Grupo__c = 'TOP');
        insert porte;
        
        Account AccountTest = new Account(
            Name = 'Cliente BLD OU 3LC2',
            RecordTypeId = CNPJ8_RECTYPE_ID,
            Porte_Empresa__c = porte.Id,
            Priority__c = 'NORMAL',
            Tipo_de_Documento__c = 'CNPJ',
            cnpj__c = '71334787',
            Cliente_Mobile_IW__c = true,
            ownerId= userId
        );

        insert AccountTest;

        opportunity = new Opportunity(Name = 'Test VN #1',
                                          AccountId = AccountTest.Id,
                                          OwnerId = user.Id,
                                          StageName = '1051 - Prospecção',
                                          Prazo_Contratual_Meses__c = '12',
                                          CloseDate = system.today(),
                                          RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Oportunidade padrão').getRecordTypeId(),
                                          CampaignId = null,
                                          Trade_Inn__c = '1',
                                          Cidade_Foco__c = 'Não',
                                          Origem__c = 'Renovação Contratual',
                                          Servico_face_cliente__c = 'VLN');
        
        insert opportunity;
    }

    @IsTest
    public void unitTest(){

        Map<String,String> AccountIdXOwner = new Map<String,String>();
        List<String> email = new List<String>();
        email.add('teste@teste.com.br');

        Account acc = [SELECT Id, OwnerId FROM Account Limit 1];

        AccountIdXOwner.put(acc.Id, acc.OwnerId);

        Test.startTest();
            BatchAjusteDeCarteiraOpportunities bsc = new BatchAjusteDeCarteiraOpportunities(AccountIdXOwner, email);        
            Id batchId = Database.executeBatch(bsc);
        Test.stopTest();

    }

}
