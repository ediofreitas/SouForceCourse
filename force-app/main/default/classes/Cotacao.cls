public with sharing class Cotacao {
    public String code;          //Moeda de origem
    public String codein;        // Moeda de destino 
    public String name;          // Nome da moeda
    public String high;          // Maior preço do dia
    public String low;           // Menos preço do dia
    public String var;           // Variação
    public String pct;           // Percentual da variação
    public String bid;           // Valor de compra
    public String ask;           // Valor de Venda
    public String timestamp;     // Data da cotação em timestamp 
    public String create_date;   // Data da tocação

    public static List<Cotacao> parse(String jsonString){
        return (List<Cotacao>)Json.deserialize(jsonString, List<Cotacao>.class);
    }
}