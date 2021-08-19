public with sharing class CloseOpenOpportunities implements DataBase.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC){

        String query = 'SELECT ID FROM OPPORTUNITY WHERE LastModifiedDate <= last_n_days:1 and StageName != \'Closed\'';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Opportunity> scope){

        for(Opportunity opp : scope){
            opp.StageName = 'Closed';
        }
        update scope;
    }

    public void finish(DataBase.BatchableContext BC){

    }
    
}
