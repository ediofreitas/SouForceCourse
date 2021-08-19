public with sharing class CotacaoService {

   private final static String serviceURL = 'https://economia.awesomeapi.com.br/json/daily/{origem}/1';

   public static List<Cotacao> getCotacao(String moedaOrigem){

        String endpoint = serviceURL.replace('{origem}', moedaOrigem);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setTimeout(12000);
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            String jsonString = response.getBody();

            return Cotacao.parse(jsonString);
        }else{ 
            Map<String, Object> error = new Map<String, Object>();
            error.put('statusCode',response.getStatusCode());
            error.put('status', response.getStatus());
            error.put('body', response.getBody());

            throw new CotacaoServiceException(JSON.serialize(error));
        }

    }

    public class CotacaoServiceException extends Exception {}
    

}