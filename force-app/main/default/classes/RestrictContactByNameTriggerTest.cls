@isTest
public class RestrictContactByNameTriggerTest {
    
    @isTest
    static void testRestrictContactByNameTrigger() {
        
        // Test inserting Contacts
        Test.startTest();
        
        // Create Contacts with mixed valid and invalid last names
        List<Contact> contactsToInsert = ContactTestDataFactory.createTestContacts(
            new List<String>{'Smith', 'Johnson', 'INVALIDNAME', 'Doe'}
        );
        
        try {
            insert contactsToInsert;
            // Iterate through contacts, checking for trigger errors
            for (Contact con : contactsToInsert) {
                if (con.LastName.equalsIgnoreCase('INVALIDNAME')) {
                    System.assert(false, 'Expected error for last name "INVALIDNAME" during insert.');
                }
            }
        } catch (DmlException e) {
            for (SObject so : e.getDmlMessage(0)) {
                if (so instanceof Contact && ((Contact)so).LastName.equalsIgnoreCase('INVALIDNAME')) {
                    String expectedMessage = 'The Last Name "INVALIDNAME" is not allowed.';
                    System.assert(e.getMessage().contains(expectedMessage),
                        'Error message verification failed for contact with last name: "INVALIDNAME".');
                }
            }
        }
        
        Test.stopTest();

        // Test updating Contacts
        Test.startTest();
        
        // Insert contacts with valid names first for update test
        List<Contact> validContacts = ContactTestDataFactory.createTestContacts(
            new List<String>{'Williams', 'Taylor', 'Brown'}
        );
        insert validContacts;
        
        // Modify last name to "INVALIDNAME" and attempt update
        for (Contact con : validContacts) {
            con.LastName = 'INVALIDNAME';
        }

        try {
            update validContacts;
            System.assert(false, 'Expected error for last name "INVALIDNAME" during update.');
        } catch (DmlException e) {
            for (SObject so : e.getDmlMessage(0)) {
                if (so instanceof Contact && ((Contact)so).LastName.equalsIgnoreCase('INVALIDNAME')) {
                    String expectedUpdateMessage = 'The Last Name "INVALIDNAME" is not allowed.';
                    System.assert(e.getMessage().contains(expectedUpdateMessage),
                        'Error message verification failed during update for contact with last name: "INVALIDNAME".');
                }
            }
        }
        
        Test.stopTest();
    }
}
