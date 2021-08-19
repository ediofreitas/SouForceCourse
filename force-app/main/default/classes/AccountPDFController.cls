public class AccountPDFController {

    public Id accountId;

    public AccountPDFController() {

        this.accountId = Apexpages.currentPage().getParameters().get('Id');
    }

    public Account getCurrentAccount(){
        return [SELECT Id, Name, Website, Phone FROM Account WHERE id =: this.accountId];
    }

    public List<String> getContacts(){
        List<String> contatosInfo = new List<String>();
        for(Contact contato : [SELECT FirstName, LastName, Email FROM Contact WHERE AccountId =: this.accountId]){
            String infoFormat = 'Name {0} {1} | Email {2}';
            contatosInfo.add(String.format(infoFormat, new List <Object> {contato.FirstName, contato.LastName, contato.Email}));
        }
        return contatosInfo;
    }

}