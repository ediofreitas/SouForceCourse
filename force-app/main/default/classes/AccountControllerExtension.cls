public with sharing class AccountControllerExtension {

    public List<Contact> listContacts {get;set;}
    List<Contact> listToDelete;
    public Account account {get;set;}
    Apexpages.StandardController controller {get;set;}

    public AccountControllerExtension(Apexpages.StandardController standardController) {
        this.account = standardController.getRecord() == null ? new Account() : (Account) standardController.getRecord();
        this.controller = standardController;
        this.listContacts = new List<Contact>();
        this.listToDelete = new List<Contact>();

        if(this.account.Id != null){
            this.listContacts = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Accountid =: this.account.Id];
        }
    }

    public PageReference addContact(){
        this.listContacts.add(new Contact());

        return null;
    }

    public Pagereference deleteContact(){

        String index = Apexpages.currentPage().getParameters().get('index');
        Contact contact = this.listContacts.remove(Integer.valueOf(index));

        if(contact.id != null){
            this.listToDelete.add(contact);
        }
        return null;
    }

    public Pagereference saveAccount(){
        upsert account;
        
        for(Contact contato : listContacts){
            contato.AccountId = account.Id;
        }

        upsert listContacts;

        if(!listToDelete.isEmpty()){
            delete this.listToDelete;
        }

        Apexpages.StandardController controller = new Apexpages.StandardController(account);
        return controller.view(); 
    }

    public Pagereference doCancel(){

        return controller.cancel();

    }

}