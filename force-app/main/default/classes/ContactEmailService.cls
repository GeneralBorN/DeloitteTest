public class ContactEmailService {
    
    public static Id updateContactEmails(List<Id> contactIds) {
        // TODO: Validate that contactIds is not null or empty
        if(contactIds == null || contactIds.isEmpty()){
            return null;
        }
        
        // TODO: Create new ContactEmailUpdateQueueable instance
        ContactEmailUpdateQueueable job = new ContactEmailUpdateQueueable(contactIds);
        
        // TODO: Enqueue the job and return the job ID
        return System.enqueueJob(job);
    }
    
    // Bonus: Method to check Apex Job Status
    public static AsyncApexJob checkJobStatus(Id jobId) {
        // TODO: Query AsyncApexJob to get job status
        return  [SELECT Id, Status, NumberOfErrors, CompletedDate FROM AsyncApexJob WHERE Id = :jobId];
        // Return: Id, Status, NumberOfErrors, CompletedDate
    }
    
    // Bonus: Method to get contacts without emails
    public static List<Contact> getContactsNeedingEmails() {
        // TODO: Return contacts where Email = null
        return [SELECT Id, Name, Email FROM Contact WHERE Email = null];
    }
}