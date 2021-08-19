trigger AccountTrigger on Account (before insert, after insert, before update, after update) {

    if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccountTriggerHandler.onBeforeInsert(Trigger.new, Trigger.newMap);
        }
        if(Trigger.isAfter){
            AccountTriggerHandler.onAfterInsert(Trigger.new, Trigger.newMap);
        }
    }

    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            AccountTriggerHandler.onBeforeUpdate(Trigger.new);
        }
        if(Trigger.isAfter){
        }
    }
    

}