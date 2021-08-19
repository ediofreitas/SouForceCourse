public with sharing class Carro {
    public Integer capacidadeDoTanque {get;set;}
    public Integer tamanhoDaRoda {get;set;}
    private String tipoDeCarroceria {get;set;}
    public Decimal potenciaDoMotor {get;set;}
    public String cor {get;set;}

    public Carro(String cor, String tipoDeCarroceria) {
        this.cor = cor;
        this.tipoDeCarroceria = tipoDeCarroceria;
    }

    public String getTipoDeCarroceria(){
        return this.tipoDeCarroceria;
    }

    public void setPotenciaDoMotor(Decimal potencia){
        this.potenciaDoMotor = potencia;
    }
}