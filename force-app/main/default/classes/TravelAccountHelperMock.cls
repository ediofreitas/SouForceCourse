public class TravelAccountHelperMock implements HttpCalloutMock{
   
    public HttpResponse respond(HTTPRequest req){
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{"cep": "21940-460","logradouro": "Praça Jerusalém","complemento": "","bairro": "Jardim Guanabara","localidade": "Rio de Janeiro","uf": "RJ","ibge": "3304557","gia": "","ddd": "21","siafi": "6001"}');

        return response;

    }

}
 