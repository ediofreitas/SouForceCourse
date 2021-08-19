public with sharing class AccountTriggerHelper {
   
    public static void formatPhone(Account conta){

        String areaCode = conta.Phone.substring(0, 2);
        String firstNumbers = conta.Phone.substring(2, 7);
        String LastNumbers = conta.Phone.substring(7);

        conta.Phone = String.format('({0}) {1}-{2}', new List<Object>{areaCode, firstNumbers, LastNumbers});
    }
}