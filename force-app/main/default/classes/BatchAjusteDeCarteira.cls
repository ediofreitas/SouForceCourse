public class BatchAjusteDeCarteira implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
	static final String CNPJ8_RECTYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CNPJ-08').getRecordTypeId();																															  
    public Map<String, List<Map<String, String>>> resultMap = new Map<String, List<Map<String, String>>>();
    public List<String> emailList = new List<String>();
    public List<String> errorMessages = new List<String>();

    public List<Staging_de_Conta__c> start(Database.BatchableContext BC){
        List<Staging_de_Conta__c> stagingList = [
            SELECT
                Id, Porte__c, Cnpj__c, Matricula__c, Tipo_de_Ajuste__c, Owner.email, Status_Carga__c,
            	Quantidade_de_Tentativas__c, Elegivel_a_processamento__c
            FROM
                Staging_de_Conta__c
            WHERE
                Tipo_de_Alteracao__c = 'Ajuste de Carteira em Lote' AND 
                Status_Carga__c = 'Pendente de Integração' AND 
                Elegivel_a_processamento__c = true
            
        ];
        
        return stagingList;
    }
    public void execute(Database.BatchableContext BC, List<Staging_de_Conta__c> scope){
       // System.debug('Entrou no Execute');
        ManageAccount.runPreventOwnerChangeFromAccount = false;
        //Set para armazenar todos os CNPJs que serão buscados
        Set<String> cnpjs = new Set<String>();
        //Map para armazenar todas as matrículas
        Map<String, Id> matriculaXUsuario = new Map<String, Id>();
        //Map para armazenar Tipo de Ajuste com seus respectivos CNPJs
        Map<String, Set<String>> acaoXCNPJ = new Map<String, Set<String>>();
        //Map para armazenar CNPJ de uma conta com seu respectivo ID
        Map<String, Id> CNPJxAccountId = new Map<String, Id>();
        //Map para armazenar os stagings que sofrerão DMLs
        Map<String, List<Staging_de_Conta__c>> stagesToBeUpdated = new Map<String, List<Staging_de_Conta__c>>();
        stagesToBeUpdated.put('SUCCESS', new List<Staging_de_Conta__c>());
        stagesToBeUpdated.put('ERROR', new List<Staging_de_Conta__c>());
        

        for(Staging_de_Conta__c tmp: scope){

            cnpjs.add(tmp.Cnpj__c);

            if(!emailList.contains(tmp.owner.email)){
                emailList.add(tmp.owner.email);
            }
            
            if(!acaoXCNPJ.containsKey(tmp.Tipo_de_Ajuste__c)){
                acaoXCNPJ.put(tmp.Tipo_de_Ajuste__c, new Set<String>());
            }
            acaoXCNPJ.get(tmp.Tipo_de_Ajuste__c).add(tmp.Cnpj__c);
            matriculaXUsuario.put(tmp.Matricula__c, null);
        }

        for(Account tmp: [SELECT Id, CNPJ__c FROM Account WHERE RecordTypeId =: CNPJ8_RECTYPE_ID AND CNPJ__c IN: cnpjs]){
            CNPJxAccountId.put(tmp.CNPJ__c, tmp.Id);
        }

        for(User tmp: [SELECT Id, Enrollment__c FROM user WHERE Enrollment__c IN :matriculaXUsuario.keySet()]){
            matriculaXUsuario.put(tmp.Enrollment__c, tmp.Id);
        }
        
        Map<String, List<Account>> cnpj08XCnpj14 = new Map<String, List<Account>>();
        List<Account> cnpjs_14 = [
                SELECT
                    Id, ParentId, CNPJ__c, Porte_Empresa__c 
                FROM
                    Account
                WHERE 
					ParentId != NULL AND					 
                    Parent.CNPJ__c IN :cnpjs
            ];
        
        List<String> cnpj14_ids = new List<String>();

        if(CNPJxAccountId.size() > 0){
            for(Account tmp: cnpjs_14){
                if(tmp.ParentId != null){
                    cnpj14_ids.add(tmp.Id);
                 	if(!cnpj08XCnpj14.containsKey(tmp.ParentId)){
                        cnpj08XCnpj14.put(tmp.ParentId, new List<Account>());
                    }
                    
                    cnpj08XCnpj14.get(tmp.parentId).add(tmp);   
                }
            }
        }


        AggregateResult[] oppcount = [SELECT AccountId, count(id) FROM Opportunity WHERE AccountId IN :cnpj14_ids AND
                                                                        ((RecordType.DeveloperName = 'Oportunidade_pai' AND StageName <> 'Fechada') OR (
                                                                        ( (RecordType.DeveloperName = 'Oportunidade_filha' OR RecordType.DeveloperName = 'Oportunidade_lead' OR RecordType.DeveloperName = 'Oportunidade_padrao') AND
                                                                        (StageName <> '1056 - Perdida' AND StageName <> '1057 - Ganha' AND StageName <> '1050 - Cancelada' AND StageName <> '1058 - Desativação'))))
                                          GROUP BY AccountId];
        Map<String,Integer> cnpj14XnumberOfOpp = new Map<String,Integer>();
        for (AggregateResult account : oppcount) {			
               cnpj14XnumberOfOpp.put((String)account.get('AccountId'),(Integer)account.get('expr0'));
        }


        Map<String,Id> porteXid = new Map<String,Id>();

        for(Porte__c porte : [SELECT Id,Name FROM Porte__c]){
            porteXid.put(porte.Name,porte.Id);
        }

        Map<String, Account> accountByCNPJ = new Map<String, Account>();
        List<Account> accountsToBeUpdated = new List<Account>();
        Map<String, List<Staging_de_Conta__c>> CNPJXStage = new Map<String, List<Staging_de_Conta__c>>();
        for(Staging_de_Conta__c stage: scope){
            if(CNPJxAccountId.containsKey(stage.Cnpj__c)){
    
                if(!accountByCNPJ.containsKey(stage.Cnpj__c)){
                    Account tmp = new Account();
                    tmp.Id = CNPJxAccountId.get(stage.Cnpj__c);
                    tmp.CNPJ__c = stage.Cnpj__c;
                    accountByCNPJ.put(stage.Cnpj__c, tmp); //cnpj8, obj conta
                }
    
                if(!CNPJXStage.containsKey(stage.Cnpj__c)){
                    CNPJXStage.put(stage.Cnpj__c, new List<Staging_de_Conta__c>());
                }
    
                Account acc = accountByCNPJ.get(stage.Cnpj__c);
                CNPJXStage.get(stage.Cnpj__c).add(stage);
                
                if(stage.Tipo_de_Ajuste__c == 'Porte'){
                    acc.Porte_Empresa__c = (id) porteXid.get(stage.porte__c);
                }else if(stage.Tipo_de_Ajuste__c == 'Migração + Porte'){
                    acc.OwnerId = matriculaXUsuario.get(stage.Matricula__c);
                    acc.Porte_Empresa__c = (id) porteXid.get(stage.porte__c);
                }else if(stage.Tipo_de_Ajuste__c == 'Migração'){
                    acc.OwnerId = matriculaXUsuario.get(stage.Matricula__c);
                }

                accountsToBeUpdated.add(acc);
                String errorMsg;
                    if(cnpj08XCnpj14.containsKey(acc.Id)){
                        for(Account cnpj14Account: cnpj08XCnpj14.get(acc.Id)){
                        
                            if(stage.Tipo_de_Ajuste__c == 'Porte'){
                                cnpj14Account.Porte_Empresa__c = acc.Porte_Empresa__c;
                            }else if(stage.Tipo_de_Ajuste__c == 'Migração + Porte'){
                                cnpj14Account.OwnerId = acc.OwnerId;
                                cnpj14Account.Porte_Empresa__c = acc.Porte_Empresa__c;
                            }else if(stage.Tipo_de_Ajuste__c == 'Migração'){
                                cnpj14Account.OwnerId = acc.OwnerId;
                            }
                            try{
                                System.debug('cnpj14Account.Id = ' + cnpj14Account.Id);
                                System.debug('cnpj14XnumberOfOpp = ' + cnpj14XnumberOfOpp.get(cnpj14Account.Id));   
                                Integer numberOfOpp = cnpj14XnumberOfOpp.get(cnpj14Account.Id);
                                if(numberOfOpp == null || numberOfOpp < 1000){
                                    accountsToBeUpdated.add(cnpj14Account);
                                }else{
                                    throw new BusinessException('Empresa com mais de 1000 oportunidades. Processamento não executado para a empresa com ID: '+cnpj14Account.Id, 'BatchAjusteDeCarteira.execute');
                                }
                            }catch(BusinessException e){            
                                /*errorMsg = e.causa + ': ' + e.mensagem;
                                errorMessages.add(errorMsg);
                                System.debug(e.mensagem); */
                                Map<String, String> notifyUserWithData = new Map<String, String>();
                                notifyUserWithData.put('CNPJ', cnpj14Account.CNPJ__c);
                                notifyUserWithData.put('Descrição do Erro', e.mensagem);
                                notifyUserWithData.put('Momento do Erro', 'Pré inserção no Radar');
                                addResultToMap('Falha_numero_de_Oportunidades', notifyUserWithData);           
                            }
                        }  
                    }else{
                        stage.Status_Carga__c = 'Falha Radar';
                        stage.Motivo_do_erro__c = 'CNPJ informado não encontrado.';
                        stage.Quantidade_de_Tentativas__c = stage.Quantidade_de_Tentativas__c != null ? stage.Quantidade_de_Tentativas__c + 1 : 1;
                        stagesToBeUpdated.get('ERROR').add(stage);

                        Map<String, String> notifyUserWithData = new Map<String, String>();
                        notifyUserWithData.put('CNPJ', stage.cnpj__c);
                        notifyUserWithData.put('Descrição do Erro', 'CNPJ informado não encontrado.');
                        notifyUserWithData.put('Momento do Erro', 'Inserção no Radar');
                        addResultToMap('Error', notifyUserWithData);
                    }
            }
        }

        ManageAccount.runSincronizePortAndOwnerIdOnCnpj08Update = false;
        Database.UpsertResult[] accountUpdateResults = Database.upsert(accountsToBeUpdated, false);
        for(Integer index = 0, size = accountUpdateResults.size(); index < size; index++) {
            if(accountUpdateResults[index].isSuccess()) {

                Map<String, String> notifyUserWithData = new Map<String, String>();
                notifyUserWithData.put('CNPJ', accountsToBeUpdated[index].cnpj__c);
                notifyUserWithData.put('ID', accountsToBeUpdated[index].Id);
                addResultToMap('Success', notifyUserWithData);

                if(CNPJXStage.containsKey(accountsToBeUpdated[index].CNPJ__c)){
                    for(Staging_de_Conta__c tmp: CNPJXStage.get(accountsToBeUpdated[index].CNPJ__c)){
                        tmp.Status_Carga__c = 'Pendente de Integração';
                        tmp.Tipo_de_Alteracao__c = 'Alteração Conta CLE';
                        tmp.Quantidade_de_Tentativas__c++;

                        stagesToBeUpdated.get('SUCCESS').add(tmp);
                    }
                }
            }else{
                String errorMsg = '';

                for(Database.Error err : accountUpdateResults[index].getErrors()) {
                    errorMsg += err.getMessage();
                }
				System.debug('errorMsg: '+errorMsg);
                if(CNPJXStage.containsKey(accountsToBeUpdated[index].CNPJ__c)){
                    for(Staging_de_Conta__c tmp: CNPJXStage.get(accountsToBeUpdated[index].CNPJ__c)){
                        tmp.Status_Carga__c = 'Falha Radar';
                        tmp.Motivo_do_erro__c = errorMsg;
                        tmp.Quantidade_de_Tentativas__c++;

                        Map<String, String> notifyUserWithData = new Map<String, String>();
                        notifyUserWithData.put('CNPJ', accountsToBeUpdated[index].cnpj__c);
                        notifyUserWithData.put('Descrição do Erro', errorMsg);
                        notifyUserWithData.put('Momento do Erro', 'Inserção no Radar');
                        addResultToMap('Error', notifyUserWithData);

                        stagesToBeUpdated.get('ERROR').add(tmp);
                    }
                }
            }
        }

        List<Staging_de_Conta__c> stagingToPerformDML = new List<Staging_de_Conta__c>();
        stagingToPerformDML.addAll(stagesToBeUpdated.get('SUCCESS'));
        stagingToPerformDML.addAll(stagesToBeUpdated.get('ERROR'));

        System.debug('Stagings a serem atualizados: ' + stagingToPerformDML.size());
        System.debug('Stagings: ' + stagingToPerformDML);

        if(stagingToPerformDML.size() > 0){
            try{
                update stagingToPerformDML;
            }catch(Exception e){
                System.debug('Falha na atualização do staging: ' + stagingToPerformDML + '. Erro: '+e.getMessage());
            }
        }

    }
    
    public void finish(Database.BatchableContext BC){
    //    System.debug('ENTROU NO FINISH');
    //    System.debug('LISTA DE E-MAIL TAMANHO: '  + emailList.size());
    // email para contas com mais de 1000 opps

        String emailSubject = 'Atualização de contas CNPJ14 - ';
        String msgCorpo;
        if (errorMessages.size() > 0){
            emailSubject += errorMessages.size() + ' erro(s).';    
            msgCorpo = 'Segue a lista de erros encontrados na atualização das contas CNPJ14 : '+ errorMessages;
        }else{
            emailSubject += 'Sucesso.';    
            msgCorpo = 'Não foram encontrados erros na atualização das contas CNPJ14.';            
        }

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(emailList);
        email.setSubject(emailSubject);
        email.setPlainTextBody(msgCorpo);
        
        //System.debug('msgCorpo: '+msgCorpo);
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

        //termina aqui o email dos erros de mais de 1000 opps

        List<Messaging.EmailFileAttachment> anexos = new List<Messaging.EmailFileAttachment>();
        if(resultMap.containsKey('Success') && resultMap.get('Success').size() > 0){
     //       system.debug('SUCESSO');
            Messaging.EmailFileAttachment csvAttcSucesso = new Messaging.EmailFileAttachment();
            blob csvBlobSucesso = Blob.valueOf(generateCSV(resultMap.get('Success')));
            string csvnameSucesso= 'Sucesso.csv';
            csvAttcSucesso.setFileName(csvnameSucesso);
            csvAttcSucesso.setBody(csvBlobSucesso);
            
            anexos.add(csvAttcSucesso);
        }
        
        if(resultMap.containsKey('Error') && resultMap.get('Error').size() > 0){
            system.debug('ERRO');
            Messaging.EmailFileAttachment csvAttcFalha = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(generateCSV(resultMap.get('Error')));
            string csvname= 'Erro.csv';
            csvAttcFalha.setFileName(csvname);
            csvAttcFalha.setBody(csvBlob);
            
            anexos.add(csvAttcFalha);
        }

        if(resultMap.containsKey('Falha_numero_de_Oportunidades') && resultMap.get('Falha_numero_de_Oportunidades').size() > 0){
            system.debug('ERRO');
            Messaging.EmailFileAttachment csvAttcFalha = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(generateCSV(resultMap.get('Falha_numero_de_Oportunidades')));
            string csvname= 'Falha_numero_de_Oportunidades.csv';
            csvAttcFalha.setFileName(csvname);
            csvAttcFalha.setBody(csvBlob);
            
            anexos.add(csvAttcFalha);
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailList);
        mail.setSubject('Ajuste de Carteira');
        mail.setPlainTextBody('Processo executado, arquivo anexo.');
        
        if(!anexos.isEmpty()){
            mail.setFileAttachments(anexos);
        }
        if(emailList.size() > 0){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
         
    }

    public void addResultToMap(String tipoDeResultado, Map<String, String> rowItem){
        if(!resultMap.containsKey(tipoDeResultado)){
            resultMap.put(tipoDeResultado, new List<Map<String, String>>());
        }

        resultMap.get(tipoDeResultado).add(rowItem);
    }
    
    public String generateCSV(List<Map<String, String>> data){
        Set<String> csvHeader = data[0].keyset();
        List<String> csvBody = new List<String>();
        String csvHeaderText = String.join((Iterable<String>)csvHeader, ',');
        for(Map<String, String> tmp: data){
            String csvRowText = String.join(tmp.values(), ',');
            csvBody.add(csvRowText);
        }
        
        String fullCSV = csvHeaderText +'\n'+String.join(csvBody, '\n');
        return fullCSV;
    }
}