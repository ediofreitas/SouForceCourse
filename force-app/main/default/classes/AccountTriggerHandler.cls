public with sharing class AccountTriggerHandler {
    
    public static void onBeforeInsert(List <Account> triggerNewList, Map<Id, Account> triggerNewMap){
        
        for(Account conta : triggerNewList){
            if(conta.Phone == null ){
                    conta.addError('Telefone não pode ser nulo');
            }else if(conta.Phone.length() < 11){
                	conta.addError('Telefone tem que ter 11 digitos');
            }else{
                AccountTriggerHelper.formatPhone(conta);
            }
        }
    }
    
    public static void onAfterInsert(List <Account> triggerNewList, Map<Id, Account> triggerNewMap){

        List<Account> travelAccountList = new List<Account>();

        for(Account conta : triggerNewList){
            if(conta.RecordTypeId == Schema.SobjectType.Account.getRecordTypeInfosByDeveloperName().get('Travel_Detail').getRecordTypeId()){
                travelAccountList.add(conta);
            }
        }
        
        System.enqueueJob(new TravelAccountQueueable(travelAccountList));
    }

}