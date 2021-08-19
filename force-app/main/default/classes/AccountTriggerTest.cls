@IsTest
public with sharing class AccountTriggerTest {
    
    @TestSetup
    static void makeData(){
        Account acc3 = new Account(Name='Acc3', Phone='11111111111');

       List<Account> accList = new List<Account>();
        accList.add(acc3);

        insert accList;
    }

    @IsTest
    static void unitTest(){

        Account acc1 = new Account(Name='Acc');
        Account acc2 = new Account(Name='Acc2', Phone='111');
        Account acc3 = new Account(Name='Acc3', Phone='11111111111');

       List<Account> accList = new List<Account>();
        accList.add(acc1);
        accList.add(acc2);
        accList.add(acc3);

        //insert accList;

        Test.startTest();
            Database.SaveResult[] sr = Database.insert(accList, false);
        Test.stopTest();
    }

    @IsTest
    static void unitTest2(){

        Account acc = [SELECT Id, Name, Phone FROM Account WHERE Name ='Acc3'];
            acc.Name = 'Teste';
            acc.Phone = '22222222222';
        //insert accList;
        
        Test.startTest();
            update acc;
            System.debug(acc);
            //Database.SaveResult[] sr = Database.update(accList, false);
        Test.stopTest();
    }
}
