public class MergeContactService {
    
    public static void mergeAccountsExample(Contact masterContact, Contact duplicateContact) {
        
        // Merge the two accounts, with with ‘merge’ operator        
    try {
            merge masterContact duplicateContact;
            System.debug('Merge successful. Master Account ID: ' + masterContact.Id);
        } catch (DmlException e) {
            System.debug('An error occurred while merging accounts: ' + e.getMessage());
        }
    }
}
