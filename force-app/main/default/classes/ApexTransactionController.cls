public with sharing class ApexTransactionController {
    public static void saveAccount() {

        System.debug('Method Started');

        Account account = new Account(Name='Test Apex Transaction', Phone='11111111111');
        insert account;

        Contact contact = new Contact (Account= account, LastName='Test Apex Transaction Contact');
        insert contact;

        Case caseAcc = new Case(Account= account, Subject='Test Apex Transaction Case');
        insert caseAcc;

        System.debug('Method Finished');

    }

}