public class ViewAccountDetailController {

    public Id accountId;
    public List<Contact> listContact {get;set;}
    public Boolean isEditMode {get;set;}

    public ViewAccountDetailController(Apexpages.StandardController standardController) {
        this.accountId = standardController.getId();
        this.listContact = getContact();
        this.isEditMode = false;
    }

    public List<Contact> getContact(){
        return [SELECT ID, FIRSTNAME, LASTNAME, EMAIL FROM CONTACT WHERE ACCOUNTID =: this.accountid];
    }

    public Pagereference newContact(){
        this.listContact.add(new Contact(AccountId = this.accountid));
        return null;
    }

    public Pagereference deleteContact(){

        String index = Apexpages.currentPage().getParameters().get('index');
        Contact contact = this.listContact.remove(Integer.valueOf(index));

        if(contact.id != null){
            delete contact;
        }

        return null;
    }

    public Pagereference editContacts(){
        this.isEditMode = true;

        return null;
    }

    public Pagereference saveContacts(){
        upsert listContact;

        this.isEditMode = false;
        
        return null;
    }



}