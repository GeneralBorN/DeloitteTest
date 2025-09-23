@isTest
public class TestRestrictContactByName {
    @isTest
    static void TestRestrictedContactsNames(){
        // Test data setup
        Contact validContact = new Contact(FirstName = 'John', LastName = 'Doe');
        Contact invalidContact = new Contact(FirstName = 'Jane', LastName = 'INVALIDNAME');

        // Insert valid contact
        insert validContact;

        // Attempt to insert invalid contact and capture the exception
        Test.startTest();
        try {
            insert invalidContact;
            // If no exception is thrown, fail the test
            System.assert(false, 'Expected an exception for invalid last name.');
        } catch (DmlException e) {
            // Verify the error message
            System.assert(e.getMessage().contains('The Last Name "INVALIDNAME" is not allowed.'));
        }
        Test.stopTest();

        // Attempt to update the valid contact to have an invalid last name
        validContact.LastName = 'INVALIDNAME';

        Test.startTest();
        try {
            update validContact;
            // If no exception is thrown, fail the test
            System.assert(false, 'Expected an exception for invalid last name on update.');
        } catch (DmlException e) {
            // Verify the error message
            System.assert(e.getMessage().contains('The Last Name "INVALIDNAME" is not allowed.'));
        }
        Test.stopTest();
    }
}