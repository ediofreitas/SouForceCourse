public with sharing class AccountActivitiesSchedule implements Schedulable{
    public AccountActivitiesSchedule() {

    }

    public void execute(SchedulableContext sc){

        List<Opportunity> opportunities = [SELECT AccountId, OwnerId FROM Opportunity WHERE LastModifiedDate <= last_n_days:2 and StageName != 'Closed'];
        List<Task> taskToInsert = New List<Task>();

        for(Opportunity opp : opportunities){
            taskToInsert.add(new Task(
                                        WhatId = opp.AccountId,
                                        OwnerId = opp.OwnerId,
                                        ActivityDate = System.now().addDays(1).date(),
                                        Subject = 'Follow up'
            ));
        }

        insert taskToInsert;
    }

}
