public with sharing class Endereco {
    @AuraEnabled
    public String cep;                 //CEP
    @AuraEnabled
    public String address_type;        // Tipo do endereço Rua, praça, etc
    @AuraEnabled
    public String address_name;        // Nome da rua
    @AuraEnabled
    public String address;             // Nome do endereço com o tipo
    @AuraEnabled
    public String state;               // Estado
    @AuraEnabled
    public String district;            // Bairro
    @AuraEnabled
    public String lat;                 // Latitude
    @AuraEnabled
    public String lng;                 // Longitude
    @AuraEnabled
    public String city;                // Cidade
    @AuraEnabled
    public String city_ibge;           // ??
    @AuraEnabled
    public String ddd;                 // ddd


    public static Endereco parse(String jsonString){

        return (Endereco)JSON.deserialize(jsonString, Endereco.class);
    }
}