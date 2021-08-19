@IsTest
public class VIewAccountDetailTest {
  

    @TestSetup
    static void makeData(){
        
        Account acc = new Account(Name='Teste', Phone='21987654321');

        insert acc;

        Contact contact = new Contact(LastName='LastTeste', Email='contactTest@test.com', AccountId = acc.id);

        insert contact;
        update acc;

    }

    @IsTest
    static void loadPageTest(){

        Account acc = [SELECT ID ,(SELECT ID FROM Contacts) FROM ACCOUNT];

        List<Contact> contacts = [SELECT Id, Name, Account.Name FROM Contact];
        System.debug(contacts);
        System.debug(acc.Contacts);

        ApexPages.StandardController standardController = new ApexPages.StandardController(acc);

        Test.startTest();

            ViewAccountDetailController pageView = new ViewAccountDetailController(standardController);

            System.assert(pageView.accountId != null);
            System.assert(!pageView.listContact.isEmpty());

        Test.stopTest();
    }

    @IsTest
    static void newContactTest(){

        Account acc = [SELECT ID FROM ACCOUNT];

        ApexPages.StandardController standardController = new ApexPages.StandardController(acc);

        Test.startTest();

            ViewAccountDetailController pageView = new ViewAccountDetailController(standardController);
            pageView.editContacts();
            pageView.newContact();
        Test.stopTest();
    }
    @IsTest
    static void saveContactTest(){

        Account acc = [SELECT ID FROM ACCOUNT];

        ApexPages.StandardController standardController = new ApexPages.StandardController(acc);

        Test.startTest();

            ViewAccountDetailController pageView = new ViewAccountDetailController(standardController);
            pageView.saveContacts();
        Test.stopTest();
    }

    @IsTest
    static void deleteContactTest(){

        Account acc = [SELECT ID FROM ACCOUNT];

        ApexPages.StandardController standardController = new ApexPages.StandardController(acc);
        Pagereference viewDetailPage = Page.viewAccountDetail;
        
        Test.startTest();

            ViewAccountDetailController pageView = new ViewAccountDetailController(standardController);

            viewDetailPage.getParameters().put('index', '0');
            Test.setCurrentPage(viewDetailPage);

            pageView.deleteContact();
        Test.stopTest();
    }
}
