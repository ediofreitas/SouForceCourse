@isTest
public class PagamentosTest {
    @isTest
    public static void pagamentoCartaoTest() {
        PagamentoCartao pc = new PagamentoCartao();
        Decimal troco = pc.cobrar(150, 150);
        System.assertEquals(0, troco);
    }
    @isTest
    public static void pagamentoDinheiroTest(){
        PagamentoDinheiro pd = new PagamentoDinheiro();
        Decimal troco = pd.cobrar(150, 200);
        System.assertEquals(50, troco);

    }

}