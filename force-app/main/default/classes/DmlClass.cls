public with sharing class DmlClass {
    public DmlClass() {
        Account acc = new Account();
        acc.Name = 'Aula DML';

        insert acc;

        Account conta = [SELECT Name FROM Account WHERE Name = 'Aula DML'];

    }
}