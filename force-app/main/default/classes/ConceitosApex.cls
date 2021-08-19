public with sharing class ConceitosApex {
    public String conceito;
    public String Visivel;
    public transient  String Oculto;

    public ConceitosApex() {
        this.conceito = 'Conceituado';
    }

    public void showConceito(){
        this.Visivel = 'Vendo';
        this.Oculto = 'Não vendo';

        System.debug(this.Oculto);
        System.debug(JSON.serialize(this));
    }

    public void mapI(){
        List<Fruta> frutas = new List<Fruta>();
        Fruta limao = new Fruta('verde', 'Limao', 'Grande');
        Fruta abacaxi = new Fruta('amarelo', 'Abacaxi', 'Grande');
        Fruta uva = new Fruta('roxo', 'Uva', 'Grande');
        frutas.add(limao);
        frutas.add(abacaxi);
        frutas.add(uva);
        
        Map<String, Fruta> minhasFrutas = new Map<String, Fruta>();

        for( Fruta fruta : frutas){
            minhasFrutas.put(fruta.Name, fruta);

        }
        System.debug(minhasFrutas);

    }
    

}