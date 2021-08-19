/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-15-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

@IsTest
public class AccountAddressServiceTest {
    
    @IsTest
    static void testSearchAccountAddress(){
        
        Test.startTest();

            Continuation con = AccountAddressService.beginSearchAddress('21940460');
            List<String> requestLabels = new List<String>(con.getRequests().keySet());
            
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('');

            Test.setContinuationResponse(requestLabels[0], response);

            Map<String, Object> responseResult <String, Object>(requestLabels, null);

        Test.stopTest();

    }

}
