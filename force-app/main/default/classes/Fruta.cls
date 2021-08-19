public with sharing class Fruta {

    Private String Cor {get;set;}
    Public String Name {get;set;}
    Public String Tamanho {get;set;}

    public Fruta() {

    }
    public Fruta(String cor, String name, String tamanho){
        this.Cor = cor;
        this.Name = name;
        this.Tamanho = tamanho;
    }

    public String getCor(){
        return this.Cor;
    }

    public void setCor(String cor){
        this.Cor = cor;
    }
}