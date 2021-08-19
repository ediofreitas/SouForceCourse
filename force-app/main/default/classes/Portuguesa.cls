public with sharing class Portuguesa extends Pizza{
    public Portuguesa() {

    }

    public override List<String> Ingredientes(){
        List <String> listaIngredientes = new List<String>();
        listaIngredientes.add('Milho');
        listaIngredientes.add('Ovo');
        listaIngredientes.add('Cebola');

        return listaIngredientes;
    }


}