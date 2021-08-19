@IsTest
public class AccountTriggerHelperTest {
    
    @IsTest
    public static void phoneFormatTest(){

        Account acc = new Account(Name='Teste', Phone='21981480378');

        Test.startTest();
            AccountTriggerHelper.formatPhone(acc);

            System.assertEquals(acc.phone, '(21) 98148-0378');

        Test.stopTest();        
    }

}
