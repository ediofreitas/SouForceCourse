public with sharing class EnderecoService {
    
    private final static String serviceUrl = 'https://cep.awesomeapi.com.br/json/{cep}';

    public static Endereco getEndereco(String cep){

        String endpoint = serviceUrl.replace('{cep}', cep);
        System.debug('ENDPOINT: '+ endpoint);
        System.debug('ENDPOINT CERTO: https://cep.awesomeapi.com.br/json/05424020');

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setTimeout(12000);
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){

            String jsonString = response.getBody();
            
            return Endereco.parse(jsonString);
        }else{
            Map<String, Object> error = new Map<String, Object>();
            error.put('statusCode', response.getStatusCode());
            error.put('status', response.getStatus());
            error.put('body', response.getBody());

            throw new EnderecoException(JSON.serialize(error));
        }

    }
    
    public void test(){
        Endereco result = EnderecoService.getEndereco('05424020');
        System.debug(result);
    }

    public class EnderecoException extends Exception{}

}