public with sharing class OpportunityFlow {
    @InvocableMethod(label='Opportunity Flow' description='Run Opportunity Flow by Apex')
    public static void execute(List <Opportunity> records) {
        //Regra de Negócio
        System.debug(records);
    }
}