public abstract with sharing class Pizza {
    
    private Integer QuantidadeDeSabores {get;set;}

    public void Pizza(Integer quantidadeDeSabores){
        this.QuantidadeDeSabores = quantidadeDeSabores;
    }

    public abstract List<String> Ingredientes();

    public void prepararPizza(){
        for(String ingrediente : Ingredientes()){
            System.debug(ingrediente);
        }
    }
}