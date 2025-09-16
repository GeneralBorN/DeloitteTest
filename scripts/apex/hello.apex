@isTest
public class MergeContactServiceTest {
    void testMergeAccountsExample() {
        // Create two contacts
        Contact masterContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        insert masterContact;

        Contact duplicateContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        insert duplicateContact;

        // Call the merge method
        MergeContactService.mergeAccountsExample(masterContact, duplicateContact);

        // Verify that the duplicate contact was merged
        Contact mergedContact = [SELECT Id FROM Contact WHERE Id = :masterContact.Id];
        System.assertNotEquals(null, mergedContact, 'Master contact should exist after merge.');

        // Check that the duplicate contact no longer exists
        List<Contact> duplicateContacts = [SELECT Id FROM Contact WHERE Id = :duplicateContact.Id];
        System.assertEquals(0, duplicateContacts.size(), 'Duplicate contact should not exist after merge.');
    }
}
