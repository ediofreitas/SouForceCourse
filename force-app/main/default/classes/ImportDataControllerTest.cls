@isTest
public class ImportDataControllerTest {
    @isTest(SeeAllData=true)
    public static void testImportData(){
        Test.startTest();
       		ImportDataController.importSampleData();
        Test.stopTest();
    }
}