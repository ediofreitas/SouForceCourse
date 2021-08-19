public with sharing class PagamentoCartao implements IPagamento {

    public PagamentoCartao() {

    }

    public Decimal cobrar(Decimal valorCompra, Decimal valorPago){
        return valorPago - valorCompra;
    }

}