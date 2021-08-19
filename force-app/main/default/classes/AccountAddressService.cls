public with sharing class AccountAddressService {
    
    @AuraEnabled(continuation=true cacheable=true)
    public static Object beginSearchAddress(string cep){
        
        Continuation con = new Continuation(120);
        con.ContinuationMethod = 'endSearchAdress';
              
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://viacep.com.br/ws/'+ cep +'/json/');
        con.addHttpRequest(request);

        return con;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> endSearchAdress(List<String> labels, Object state){

        HttpResponse response = Continuation.getResponse(labels[0]);

        return (Map<String, Object>)Json.deserializeUntyped(response.getBody());
        
    }

}
