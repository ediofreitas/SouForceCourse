public with sharing class SoqlClass {
    public SoqlClass() {
        List <Account> Contas = [SELECT Id, Name  FROM Account];
        
    }
}