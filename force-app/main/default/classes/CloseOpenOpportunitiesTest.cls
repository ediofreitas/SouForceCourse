@IsTest
public class CloseOpenOpportunitiesTest {
    
    @IsTest
    static void unitTest(){

        Opportunity opp = new Opportunity(Name='Teste', CloseDate= date.valueof('2021-08-30'), StageName = 'Prospecting');
        insert opp;

        Test.startTest();
            CloseOpenOpportunities batch = new CloseOpenOpportunities();
            Database.executeBatch(batch);
        Test.stopTest();

    }
}
