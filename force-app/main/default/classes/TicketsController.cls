public with sharing class TicketsController {
   
    @AuraEnabled (cacheable=true)
    public static List<Aeroporto__c> getAeroportos(String search){
        search += '%';

        List<Aeroporto__c> aeroportosList = [SELECT ID, NAME, Estado__r.Name, Pais__c, Sigla__c 
                                             FROM Aeroporto__c 
                                             WHERE NAME LIKE :search OR 
                                             Estado__r.Name LIKE :search OR
                                             Sigla__c LIKE :search];

        return aeroportosList;
    }

    private static Date dataParse(String dateString){
        List<String> dt = dateString.split('-');
        Date dtResult = Date.newInstance(Integer.valueOf(dt.get(0)), Integer.valueOf(dt.get(1)), Integer.valueOf(dt.get(2)));

        return dtResult;
    }

    @AuraEnabled
    public static List<ReturnVooTO> getVoos(String aeroportoOrigem, String aeroportoDestino, String dataPartida, String dataRetorno){
        
        Date dtPartida = dataParse(dataPartida);
        Date dtRetorno = dataParse(dataRetorno);


        List<Voo__c> voosOrigem = [SELECT Id, Name, Aeroporto_Chegada__r.Sigla__c, Aeroporto_Partida__r.Sigla__c, Valor__c,
                                            Duracao__c, Companhia__c, Hora_de_Partida__c, Hora_de_Chegada__c, Data_Partida__c, Data_Chegada__c
                                   FROM Voo__c
                                   WHERE Aeroporto_Partida__c =:aeroportoOrigem AND Aeroporto_Chegada__c =:aeroportoDestino AND Data_Partida__c = :dtPartida 
                                   ];

        List<Voo__c> voosRetorno = [SELECT Id, Name, Aeroporto_Chegada__r.Sigla__c, Aeroporto_Partida__r.Sigla__c, Valor__c,
                                            Duracao__c, Companhia__c, Hora_de_Partida__c, Hora_de_Chegada__c, Data_Partida__c, Data_Chegada__c 
                                   FROM Voo__c
                                   WHERE Aeroporto_Partida__c =:aeroportoDestino AND Aeroporto_Chegada__c =:aeroportoOrigem AND Data_Partida__c = :dtRetorno
                                   ];

        List<ReturnVooTO> voosList = new List<ReturnVooTO>();
        for(Voo__c vooOrigem : voosOrigem){
            for(Voo__c vooRetorno : voosRetorno){
                voosList.add(new ReturnVooTo(vooOrigem, vooRetorno));
            }
        }
        system.debug(voosList);
        return voosList;

    }

    public class ReturnVooTO {
        @AuraEnabled
        public Voo__c vooIda;
        @AuraEnabled
        public Voo__c vooVolta;

        public ReturnVooTO(Voo__c vooIda, Voo__c vooVolta){
            this.vooIda = vooIda;
            this.vooVolta = vooVolta;
        }
    }

    @AuraEnabled
    public static Ticket__c createTicket(String accountId, String vooIdaId, String vooVoltaId){
        Ticket__c ticket = new Ticket__c();
        ticket.Account__c = accountId;
        ticket.Voo_Ida__c = vooIdaId;
        ticket.Voo_Volta__c = vooVoltaId;

        insert ticket;

        return ticket;
    }
    
}