@IsTest
public class TravelAccountQueueableTest {

    @IsTest
    static void unitTest(){
        Account acc = new Account(Name='Test', Phone='11111111111');
        insert acc;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TravelAccountHelperMock());
            TravelAccountHelper.fillAddress(acc.id);
        Test.stopTest();
    }

    @IsTest
    static void unitTest2(){


        Account acc = new Account(Name='Test', TargetCountry__c='United States', Phone='11111111111');
		insert acc;
        
        List<String> accIds = new List<String>();
        accIds.add(acc.id);

        Product2 product1 = new Product2(Name='Product Test', isActive=true, ProductCode='1');
        Product2 product2 = new Product2(Name='Product Test2', isActive=true, ProductCode='2');

        insert new List<Product2>{product1, Product2};

        Pricebook2 pricebook = new Pricebook2(Name='United States PriceBook', isActive=true);

        insert pricebook;


        PricebookEntry standardPriceProduct = new pricebookEntry(Product2Id = product1.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice=300, isActive=true);

        PricebookEntry standardPriceProduct2 = new pricebookEntry(Product2Id = product2.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice=300, isActive=true);

        PricebookEntry pbe = new pricebookEntry(Product2Id = product1.Id, Pricebook2Id = pricebook.Id, UnitPrice=300, isActive=true);

        PricebookEntry pbe2 = new pricebookEntry(Product2Id = product2.Id, Pricebook2Id = pricebook.Id, UnitPrice=300, isActive=true);

        insert new List<PricebookEntry>{standardPriceProduct, standardPriceProduct2, pbe, pbe2};

        Test.startTest();
            System.enqueueJob(new TravelAccountQueueable (new List<Account>{acc}));
        Test.stopTest();

    }
}
