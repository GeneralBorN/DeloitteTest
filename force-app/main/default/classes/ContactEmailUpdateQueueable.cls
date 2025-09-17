public class ContactEmailUpdateQueueable implements Queueable {
    private List<Id> contactIds;
    
    public ContactEmailUpdateQueueable(List<Id> contactIds) {
        // TODO: Store the contactIds in the instance variable
        this.contactIds=contactIds;
    }
    
    public void execute(QueueableContext context) {
        // TODO: Query Contacts that need email updates
        List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Id IN :contactIds];
        
        // TODO: Loop through contacts and generate emails
        for(Contact cont : contacts){
            cont.Email=cont.FirstName + cont.LastName + '@example.com';
        }
                
        // TODO: Update the contacts if the list is not empty
        if(!contacts.isEmpty()){
            update contacts;
        }
    }
}